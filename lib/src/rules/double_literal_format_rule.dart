import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:dart_code_metrics/src/models/code_issue.dart';
import 'package:dart_code_metrics/src/models/code_issue_severity.dart';

import 'base_rule.dart';
import 'rule_utils.dart';

class DoubleLiteralFormatRule extends BaseRule {
  static const _failureLeadingZero =
      "Double literal shouldn't have redundant leading '0'.";
  static const _correctionCommentLeadingZero = "Remove redundant leading '0'";

  static const _failureLeadingDecimal =
      "Double literal shouldn't begin with '.'.";
  static const _correctionCommentLeadingDecimal = "Add missing leading '0'";

  static const _failureTrailingZero =
      "Double literal shouldn't have a trailing '0'.";
  static const _correctionCommentTrailingZero = "Remove redundant trailing '0'";

  const DoubleLiteralFormatRule()
      : super(
          id: 'double-literal-format',
          severity: CodeIssueSeverity.style,
        );

  @override
  Iterable<CodeIssue> check(CompilationUnit unit, Uri sourceUrl) {
    final _visitor = _Visitor();

    unit.visitChildren(_visitor);

    final issues = <CodeIssue>[];

    for (final node in _visitor.literals) {
      final lexeme = node.literal.lexeme;

      if (lexeme.startsWith('0') && lexeme[1] != '.') {
        issues.add(createIssue(
            this,
            '$_failureLeadingZero ${node.literal?.precedingComments?.toString()}',
            lexeme,
            lexeme.substring(1),
            _correctionCommentLeadingZero,
            sourceUrl,
            unit.lineInfo,
            node.offset));
      } else if (lexeme.startsWith('.')) {
        issues.add(createIssue(
            this,
            _failureLeadingDecimal,
            lexeme,
            '0$lexeme',
            _correctionCommentLeadingDecimal,
            sourceUrl,
            unit.lineInfo,
            node.offset));
      } else {
        final mantissa = lexeme.split('e').first;

        if (mantissa.contains('.') &&
            mantissa.endsWith('0') &&
            mantissa.split('.').last != '0') {
          issues.add(createIssue(
              this,
              _failureTrailingZero,
              lexeme,
              lexeme.replaceFirst(
                  mantissa, mantissa.substring(0, mantissa.length - 1)),
              _correctionCommentTrailingZero,
              sourceUrl,
              unit.lineInfo,
              node.offset));
        }
      }
    }

    return issues;
  }
}

class _Visitor extends RecursiveAstVisitor<Object> {
  final _literals = <DoubleLiteral>[];

  Iterable<DoubleLiteral> get literals => _literals;

  @override
  void visitDoubleLiteral(DoubleLiteral node) {
    _literals.add(node);
    super.visitDoubleLiteral(node);
  }
}
