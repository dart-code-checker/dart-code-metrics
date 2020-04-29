import 'package:dart_code_metrics/src/models/code_issue_severity.dart';
import 'package:meta/meta.dart';
import 'package:source_span/source_span.dart';

@immutable
class CodeIssue {
  final String ruleId;
  final CodeIssueSeverity severity;
  final SourceSpanBase sourceSpan;
  final String message;
  final String correction;
  final String correctionComment;
  final Uri ruleDocumentationUri;

  const CodeIssue({
    @required this.ruleId,
    @required this.severity,
    @required this.sourceSpan,
    @required this.message,
    this.correction,
    this.correctionComment,
    this.ruleDocumentationUri,
  });
}
