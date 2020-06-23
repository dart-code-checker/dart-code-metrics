import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:dart_code_metrics/src/models/code_issue.dart';
import 'package:dart_code_metrics/src/models/code_issue_severity.dart';

import 'base_rule.dart';
import 'rule_utils.dart';

class NoMagicNumberRule extends BaseRule {
  static const _warningMessage =
      'Avoid using magic numbers. Extract them to named constants';

  // TODO(shtepin): allow configuration of allowed values
  static const allowedMagicNumbers = [-1, 0, 1];

  const NoMagicNumberRule()
      : super(id: 'no-magic-number', severity: CodeIssueSeverity.warning);

  @override
  Iterable<CodeIssue> check(
      CompilationUnit unit, Uri sourceUrl, String sourceContent) {
    final visitor = _Visitor();

    unit.visitChildren(visitor);

    return visitor.literals
        .where((lit) =>
            lit is DoubleLiteral ||
            lit is IntegerLiteral && !allowedMagicNumbers.contains(lit.value))
        .where((lit) =>
            lit.thisOrAncestorMatching((ancestor) =>
                ancestor is VariableDeclaration && ancestor.isConst) ==
            null)
        .map((lit) => createIssue(this, _warningMessage, null, null, sourceUrl,
            sourceContent, unit.lineInfo, lit))
        .toList(growable: false);
  }
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
