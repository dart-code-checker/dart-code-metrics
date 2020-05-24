import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/source/line_info.dart';
import 'package:dart_code_metrics/src/models/code_issue.dart';
import 'package:dart_code_metrics/src/models/code_issue_severity.dart';
import 'package:source_span/source_span.dart';

import 'base_rule.dart';

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
        issues.add(_createIssue(
            '$_failureLeadingZero ${node.literal?.precedingComments?.toString()}',
            lexeme,
            lexeme.substring(1),
            _correctionCommentLeadingZero,
            sourceUrl,
            unit.lineInfo,
            node));
      } else if (lexeme.startsWith('.')) {
        issues.add(_createIssue(_failureLeadingDecimal, lexeme, '0$lexeme',
            _correctionCommentLeadingDecimal, sourceUrl, unit.lineInfo, node));
      } else {
        final mantissa = lexeme.split('e').first;

        if (mantissa.contains('.') &&
            mantissa.endsWith('0') &&
            mantissa.split('.').last != '0') {
          issues.add(_createIssue(
              _failureTrailingZero,
              lexeme,
              lexeme.replaceFirst(
                  mantissa, mantissa.substring(0, mantissa.length - 1)),
              _correctionCommentTrailingZero,
              sourceUrl,
              unit.lineInfo,
              node));
        }
      }
    }

    return issues;
  }

  CodeIssue _createIssue(
      String message,
      String issueText,
      String correction,
      String correctionComment,
      Uri sourceUrl,
      LineInfo lineInfo,
      AstNode node) {
    final offsetLineLocation = lineInfo.getLocation(node.offset);

    return CodeIssue(
      ruleId: id,
      severity: severity,
      sourceSpan: SourceSpanBase(
          SourceLocation(node.offset,
              sourceUrl: sourceUrl,
              line: offsetLineLocation.lineNumber,
              column: offsetLineLocation.columnNumber),
          SourceLocation(node.end, sourceUrl: sourceUrl),
          issueText),
      message: message,
      correction: correction,
      correctionComment: correctionComment,
    );
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
