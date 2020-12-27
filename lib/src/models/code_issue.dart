import 'package:code_checker/analysis.dart';
import 'package:meta/meta.dart';
import 'package:source_span/source_span.dart';

@immutable
class CodeIssue {
  final String ruleId;
  final Uri ruleDocumentation;
  final Severity severity;
  final SourceSpanBase sourceSpan;
  final String message;
  final String correction;
  final String correctionComment;

  const CodeIssue({
    @required this.ruleId,
    @required this.ruleDocumentation,
    @required this.severity,
    @required this.sourceSpan,
    @required this.message,
    this.correction,
    this.correctionComment,
  });
}
