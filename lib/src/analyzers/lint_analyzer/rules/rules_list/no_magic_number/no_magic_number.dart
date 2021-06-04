import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

import '../../../../../utils/node_utils.dart';
import '../../../models/internal_resolved_unit_result.dart';
import '../../../models/issue.dart';
import '../../../models/severity.dart';
import '../../models/rule.dart';
import '../../models/rule_documentation.dart';
import '../../rule_utils.dart';

part 'config_parser.dart';
part 'visitor.dart';

class NoMagicNumberRule extends Rule {
  static const String ruleId = 'no-magic-number';

  static const _warningMessage =
      'Avoid using magic numbers. Extract them to named constants or variables.';

  final Iterable<num> _allowedMagicNumbers;

  NoMagicNumberRule([Map<String, Object> config = const {}])
      : _allowedMagicNumbers = _ConfigParser.parseAllowedNumbers(config),
        super(
          id: ruleId,
          documentation: const RuleDocumentation(
            name: 'No magic number',
            brief:
                'Warns against using number literals outside of named constants or variables.',
          ),
          severity: readSeverity(config, Severity.warning),
          excludes: readExcludes(config),
        );

  @override
  Iterable<Issue> check(InternalResolvedUnitResult source) {
    final visitor = _Visitor();

    source.unit.visitChildren(visitor);

    return visitor.literals
        .where(_isMagicNumber)
        .where(_isNotInsideVariable)
        .where(_isNotInsideCollectionLiteral)
        .where(_isNotInsideConstConstructor)
        .where(_isNotInDateTime)
        .map((lit) => createIssue(
              rule: this,
              location: nodeLocation(
                node: lit,
                source: source,
                withCommentOrMetadata: true,
              ),
              message: _warningMessage,
            ))
        .toList(growable: false);
  }

  bool _isMagicNumber(Literal l) =>
      (l is DoubleLiteral && !_allowedMagicNumbers.contains(l.value)) ||
      (l is IntegerLiteral && !_allowedMagicNumbers.contains(l.value));

  bool _isNotInsideVariable(Literal l) =>
      l.thisOrAncestorMatching(
        (ancestor) => ancestor is VariableDeclaration,
      ) ==
      null;

  bool _isNotInDateTime(Literal l) =>
      l.thisOrAncestorMatching(
        (a) =>
            a is InstanceCreationExpression &&
            a.staticType?.getDisplayString(withNullability: false) ==
                'DateTime',
      ) ==
      null;

  bool _isNotInsideCollectionLiteral(Literal l) =>
      l.thisOrAncestorMatching((ancestor) => ancestor is TypedLiteral) == null;

  bool _isNotInsideConstConstructor(Literal l) =>
      l.thisOrAncestorMatching((ancestor) =>
          ancestor is InstanceCreationExpression && ancestor.isConst) ==
      null;
}
