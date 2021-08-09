import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

import '../../../../../utils/node_utils.dart';
import '../../../models/internal_resolved_unit_result.dart';
import '../../../models/issue.dart';
import '../../../models/severity.dart';
import '../../models/common_rule.dart';
import '../../models/rule_documentation.dart';
import '../../rule_utils.dart';

part 'config_parser.dart';

part 'visitor.dart';

const _defaultMinIdentifier = 3;
const _defaultMaxIdentifier = 30;

class PreferCorrectIdentifierLength extends CommonRule {
  static const String ruleId = 'prefer-correct-identifier-length';

  static const _tooShortIdentifierLength = 'Too short identifier length.';
  static const _tooLongIdentifierLength = 'Too long identifier length.';

  final int? _minLength;
  final int? _maxLength;

  PreferCorrectIdentifierLength([Map<String, Object> config = const {}])
      : _minLength = _ConfigParser.parseMinIdentifierLength(config),
        _maxLength = _ConfigParser.parseMaxIdentifierLength(config),
        super(
          id: ruleId,
          documentation: const RuleDocumentation(
            name: 'Prefer correct identifier length',
            brief: 'Warns when identifier name length very short.',
          ),
          severity: readSeverity(config, Severity.warning),
          excludes: readExcludes(config),
        );

  @override
  Iterable<Issue> check(InternalResolvedUnitResult source) {
    final visitor = _Visitor();
    source.unit.visitChildren(visitor);

    final _issue = <Issue>[];

    final _minIdentifierLength = _minLength ?? _defaultMinIdentifier;
    final _maxIdentifierLength = _maxLength ?? _defaultMaxIdentifier;

    visitor.declaration.map((node) {});

    for (final node in visitor.declaration) {
      final isLengthTooShort = node.name.length < _minIdentifierLength;
      final isLengthTooLong = node.name.length > _maxIdentifierLength;

      if (isLengthTooShort || isLengthTooLong) {
        final issue = createIssue(
          rule: this,
          location: nodeLocation(
            node: node.name,
            source: source,
            withCommentOrMetadata: true,
          ),
          message: isLengthTooShort
              ? _tooShortIdentifierLength
              : _tooLongIdentifierLength,
        );

        _issue.add(issue);
      }
    }

    return _issue;
  }
}
