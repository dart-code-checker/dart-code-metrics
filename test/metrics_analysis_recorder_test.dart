@TestOn('vm')
import 'package:dart_code_metrics/src/metrics_analysis_recorder.dart';
import 'package:dart_code_metrics/src/models/code_issue.dart';
import 'package:dart_code_metrics/src/models/code_issue_severity.dart';
import 'package:source_span/source_span.dart';
import 'package:test/test.dart';

void main() {
  group('MetricsAnalysisRecorder recordIssues', () {
    test('threw StateError if we call them in invalid state', () {
      final recorder = MetricsAnalysisRecorder();

      expect(() {
        recorder.recordIssues([]);
      }, throwsStateError);
    });
    test('aggregate issues for component', () {
      const _issueRuleId = 'ruleId1';
      const _issueMessage = 'first issue message';
      const _issueCorrection = 'correction';
      const _issueCorrectionComment = 'correction comment';

      final recorder = MetricsAnalysisRecorder()
        ..startRecordFile('/home/developer/work/project/example.dart',
            '/home/developer/work/project/')
        ..recordIssues([
          CodeIssue(
            ruleId: _issueRuleId,
            severity: CodeIssueSeverity.style,
            sourceSpan: SourceSpanBase(
                SourceLocation(1,
                    sourceUrl:
                        Uri.parse('/home/developer/work/project/example.dart'),
                    line: 2,
                    column: 3),
                SourceLocation(6,
                    sourceUrl:
                        Uri.parse('/home/developer/work/project/example.dart')),
                'issue'),
            message: _issueMessage,
            correction: _issueCorrection,
            correctionComment: _issueCorrectionComment,
          ),
        ])
        ..endRecordFile();

      expect(recorder.records().single.issues.single.ruleId, _issueRuleId);
      expect(recorder.records().single.issues.single.message, _issueMessage);
      expect(
          recorder.records().single.issues.single.correction, _issueCorrection);
      expect(recorder.records().single.issues.single.correctionComment,
          _issueCorrectionComment);
    });
  });
}
