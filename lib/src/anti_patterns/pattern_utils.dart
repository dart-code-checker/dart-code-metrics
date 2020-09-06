import 'package:analyzer/dart/ast/ast.dart';
import 'package:source_span/source_span.dart';

import '../models/design_issue.dart';
import '../models/source.dart';
import 'base_pattern.dart';

DesignIssue createIssue(BasePattern pattern, String message,
    String recommendation, Source source, Declaration issueNode) {
  final offsetLocation = source.compilationUnit.lineInfo
      .getLocation(issueNode.firstTokenAfterCommentAndMetadata.offset);
  final endLocation =
      source.compilationUnit.lineInfo.getLocation(issueNode.end);

  return DesignIssue(
    patternId: pattern.id,
    patternDocumentation: pattern.documentation,
    sourceSpan: SourceSpanBase(
        SourceLocation(issueNode.offset,
            sourceUrl: source.url,
            line: offsetLocation.lineNumber,
            column: offsetLocation.columnNumber),
        SourceLocation(issueNode.end,
            sourceUrl: source.url,
            line: endLocation.lineNumber,
            column: endLocation.columnNumber),
        source.content.substring(issueNode.offset, issueNode.end)),
    message: message,
    recommendation: recommendation,
  );
}
