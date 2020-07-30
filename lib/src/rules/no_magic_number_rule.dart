import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:dart_code_metrics/src/models/code_issue.dart';
import 'package:dart_code_metrics/src/models/code_issue_severity.dart';

import 'base_rule.dart';
import 'rule_utils.dart';

class NoMagicNumberRule extends BaseRule {
  static const String ruleId = 'no-magic-number';

  static const _warningMessage =
      'Avoid using magic numbers. Extract them to named constants';

  // TODO(shtepin): allow configuration of allowed values
  static const allowedMagicNumbers = [-1, 0, 1];

  NoMagicNumberRule({Map<String, Object> config = const {}})
      : super(
            id: ruleId,
            severity:
                CodeIssueSeverity.fromJson(config['severity'] as String) ??
                    CodeIssueSeverity.warning);

  @override
  Iterable<CodeIssue> check(
      CompilationUnit unit, Uri sourceUrl, String sourceContent) {
    final visitor = _Visitor();

    unit.visitChildren(visitor);

    return visitor.literals
        .where(_isMagicNumber)
        .where((lit) =>
            lit.thisOrAncestorMatching((ancestor) =>
                ancestor is VariableDeclaration && ancestor.isConst) ==
            null)
        .map((lit) => createIssue(this, _warningMessage, null, null, sourceUrl,
            sourceContent, unit.lineInfo, lit))
        .toList(growable: false);
  }

  bool _isMagicNumber(Literal l) =>
      l is DoubleLiteral ||
      l is IntegerLiteral && !allowedMagicNumbers.contains(l.value);
}

class _Visitor extends RecursiveAstVisitor<Object> {
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
