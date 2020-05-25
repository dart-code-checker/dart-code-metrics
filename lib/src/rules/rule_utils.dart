import 'package:analyzer/source/line_info.dart';
import 'package:dart_code_metrics/src/models/code_issue.dart';
import 'package:source_span/source_span.dart';

import 'base_rule.dart';

CodeIssue createIssue(
    BaseRule rule,
    String message,
    String issueText,
    String correction,
    String correctionComment,
    Uri sourceUrl,
    LineInfo lineInfo,
    int issueOffset) {
  final offsetLineLocation = lineInfo.getLocation(issueOffset);

  return CodeIssue(
    ruleId: rule.id,
    severity: rule.severity,
    sourceSpan: SourceSpanBase(
        SourceLocation(issueOffset,
            sourceUrl: sourceUrl,
            line: offsetLineLocation.lineNumber,
            column: offsetLineLocation.columnNumber),
        SourceLocation(issueOffset + issueText.length, sourceUrl: sourceUrl),
        issueText),
    message: message,
    correction: correction,
    correctionComment: correctionComment,
  );
}
