import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/source/line_info.dart';
import 'package:code_checker/rules.dart';
import 'package:source_span/source_span.dart';

Issue createIssue(
  Rule rule,
  String message,
  String correction,
  String correctionComment,
  Uri sourceUrl,
  String sourceContent,
  LineInfo sourceLineInfo,
  AstNode issueNode,
) {
  final offsetLocation = sourceLineInfo.getLocation(issueNode.offset);
  final endLocation = sourceLineInfo.getLocation(issueNode.end);

  return Issue(
    ruleId: rule.id,
    documentation: rule.documentation,
    severity: rule.severity,
    location: SourceSpanBase(
      SourceLocation(
        issueNode.offset,
        sourceUrl: sourceUrl,
        line: offsetLocation.lineNumber,
        column: offsetLocation.columnNumber,
      ),
      SourceLocation(
        issueNode.end,
        sourceUrl: sourceUrl,
        line: endLocation.lineNumber,
        column: endLocation.columnNumber,
      ),
      sourceContent.substring(issueNode.offset, issueNode.end),
    ),
    message: message,
    suggestion: correction,
    suggestionComment: correctionComment,
  );
}
