import 'package:analyzer/dart/ast/ast.dart';
import 'package:code_checker/analysis.dart';
import 'package:source_span/source_span.dart';

import 'base_pattern.dart';

Issue createIssue(
  BasePattern pattern,
  String message,
  String recommendation,
  ProcessedFile source,
  Declaration issueNode,
) {
  final offsetLocation = source.parsedContent.lineInfo
      .getLocation(issueNode.firstTokenAfterCommentAndMetadata.offset);
  final endLocation = source.parsedContent.lineInfo.getLocation(issueNode.end);

  return Issue(
    ruleId: pattern.id,
    documentation: pattern.documentation,
    location: SourceSpanBase(
      SourceLocation(
        issueNode.offset,
        sourceUrl: source.url,
        line: offsetLocation.lineNumber,
        column: offsetLocation.columnNumber,
      ),
      SourceLocation(
        issueNode.end,
        sourceUrl: source.url,
        line: endLocation.lineNumber,
        column: endLocation.columnNumber,
      ),
      source.content.substring(issueNode.offset, issueNode.end),
    ),
    severity: Severity.none,
    message: message,
    verboseMessage: recommendation,
  );
}
