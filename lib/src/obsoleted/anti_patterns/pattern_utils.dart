// ignore_for_file: public_member_api_docs, long-parameter-list
import 'package:analyzer/dart/ast/ast.dart';
import 'package:code_checker/rules.dart';
import 'package:source_span/source_span.dart';

import '../models/internal_resolved_unit_result.dart';
import 'base_pattern.dart';

Issue createIssue(
  BasePattern pattern,
  String message,
  String recommendation,
  InternalResolvedUnitResult source,
  Declaration issueNode,
) {
  final offsetLocation = source.unit.lineInfo
      .getLocation(issueNode.firstTokenAfterCommentAndMetadata.offset);
  final endLocation = source.unit.lineInfo.getLocation(issueNode.end);

  return Issue(
    ruleId: pattern.id,
    documentation: pattern.documentation,
    location: SourceSpanBase(
      SourceLocation(
        issueNode.offset,
        sourceUrl: source.uri,
        line: offsetLocation.lineNumber,
        column: offsetLocation.columnNumber,
      ),
      SourceLocation(
        issueNode.end,
        sourceUrl: source.uri,
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
