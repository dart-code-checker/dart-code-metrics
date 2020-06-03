import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/source/line_info.dart';
import 'package:dart_code_metrics/src/models/code_issue.dart';
import 'package:source_span/source_span.dart';

import 'base_rule.dart';

CodeIssue createIssue(
    BaseRule rule,
    String message,
    String correction,
    String correctionComment,
    Uri sourceUrl,
    String sourceContent,
    LineInfo sourceLineInfo,
    AstNode issueNode) {
  final offsetLocation = sourceLineInfo.getLocation(issueNode.offset);
  final endLocation = sourceLineInfo.getLocation(issueNode.end);

  return CodeIssue(
    ruleId: rule.id,
    severity: rule.severity,
    sourceSpan: SourceSpanBase(
        SourceLocation(issueNode.offset,
            sourceUrl: sourceUrl,
            line: offsetLocation.lineNumber,
            column: offsetLocation.columnNumber),
        SourceLocation(issueNode.end,
            sourceUrl: sourceUrl,
            line: endLocation.lineNumber,
            column: endLocation.lineNumber),
        sourceContent.substring(issueNode.offset, issueNode.end)),
    message: message,
    correction: correction,
    correctionComment: correctionComment,
  );
}
