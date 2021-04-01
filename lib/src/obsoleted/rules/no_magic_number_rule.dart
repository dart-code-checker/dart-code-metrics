import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

import '../../models/issue.dart';
import '../../models/severity.dart';
import '../../utils/node_utils.dart';
import '../../utils/rule_utils.dart';
import 'obsolete_rule.dart';

class NoMagicNumberRule extends ObsoleteRule {
  static const String ruleId = 'no-magic-number';
  static const _documentationUrl = 'https://git.io/JJwmL';

  static const _warningMessage =
      'Avoid using magic numbers. Extract them to named constants';

  final Iterable<num> _allowedMagicNumbers;

  NoMagicNumberRule({Map<String, Object> config = const {}})
      : _allowedMagicNumbers = _parseConfig(config),
        super(
          id: ruleId,
          documentationUrl: Uri.parse(_documentationUrl),
          severity: readSeverity(config, Severity.warning),
        );

  @override
  Iterable<Issue> check(ResolvedUnitResult source) {
    final visitor = _Visitor();

    source.unit?.visitChildren(visitor);

    return visitor.literals
        .where(_isMagicNumber)
        .where(_isNotInsideNamedConstant)
        .where(_isNotInsideConstantCollectionLiteral)
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

  bool _isNotInsideNamedConstant(Literal l) =>
      l.thisOrAncestorMatching(
        (ancestor) => ancestor is VariableDeclaration && ancestor.isConst,
      ) ==
      null;

  bool _isNotInDateTime(Literal l) =>
      l.thisOrAncestorMatching(
        (a) => a is MethodInvocation && a.methodName.name == 'DateTime',
      ) ==
      null;

  bool _isNotInsideConstantCollectionLiteral(Literal l) =>
      l.thisOrAncestorMatching(
        (ancestor) => ancestor is TypedLiteral && ancestor.isConst,
      ) ==
      null;

  bool _isNotInsideConstConstructor(Literal l) =>
      l.thisOrAncestorMatching((ancestor) =>
          ancestor is InstanceCreationExpression && ancestor.isConst) ==
      null;

  static Iterable<num> _parseConfig(Map<String, Object> config) =>
      config['allowed'] as Iterable<num>? ?? [-1, 0, 1];
}

class _Visitor extends RecursiveAstVisitor<void> {
  final _literals = <Literal>[];

  Iterable<Literal> get literals => _literals;

  @override
  void visitDoubleLiteral(DoubleLiteral node) {
    _literals.add(node);
    super.visitDoubleLiteral(node);
  }

  @override
  void visitIntegerLiteral(IntegerLiteral node) {
    _literals.add(node);
    super.visitIntegerLiteral(node);
  }
}
