@TestOn('vm')
import 'package:analyzer/dart/ast/ast.dart';
import 'package:dart_code_metrics/src/metrics_analysis_recorder.dart';
import 'package:dart_code_metrics/src/models/code_issue.dart';
import 'package:dart_code_metrics/src/models/code_issue_severity.dart';
import 'package:dart_code_metrics/src/models/function_record.dart';
import 'package:dart_code_metrics/src/models/scoped_declaration.dart';
import 'package:mockito/mockito.dart';
import 'package:source_span/source_span.dart';
import 'package:test/test.dart';

class FunctionDeclarationMock extends Mock implements FunctionDeclaration {}

class SimpleIdentifierMock extends Mock implements SimpleIdentifier {}

void main() {
  group('MetricsAnalysisRecorder', () {
    const filePath = '/home/developer/work/project/example.dart';
    const rootDirectory = '/home/developer/work/project/';

    group('startRecordFile', () {
      test('throws ArgumentError if we call them without filePath', () {
        expect(() {
          MetricsAnalysisRecorder().startRecordFile(null, null);
        }, throwsArgumentError);
      });

      test('throws StateError if we call them twice witout endRecordFile', () {
        final recorder = MetricsAnalysisRecorder()
          ..startRecordFile(filePath, rootDirectory);

        expect(() {
          recorder.startRecordFile(filePath, rootDirectory);
        }, throwsStateError);
      });
    });

    group('record', () {
      const functionName = 'simpleFunction';

      final simpleIdentifierMock = SimpleIdentifierMock();
      when(simpleIdentifierMock.name).thenReturn(functionName);

      final functionDeclarationMock = FunctionDeclarationMock();
      when(functionDeclarationMock.name).thenReturn(simpleIdentifierMock);

      final record = ScopedDeclaration(functionDeclarationMock, null);

      test('throws StateError if we call them in invalid state', () {
        expect(() {
          MetricsAnalysisRecorder().record(record, null);
        }, throwsStateError);
      });

      test('throws ArgumentError if we call them without record', () {
        expect(() {
          MetricsAnalysisRecorder()
            ..startRecordFile(filePath, rootDirectory)
            ..record(null, null);
        }, throwsArgumentError);
      });

      test('store record for component', () {
        const functionRecord = FunctionRecord(
          firstLine: 1,
          lastLine: 2,
          argumentsCount: 3,
          cyclomaticComplexityLines: {},
          linesWithCode: [],
          operators: {},
          operands: {},
        );

        final recorder = MetricsAnalysisRecorder()
          ..startRecordFile(filePath, rootDirectory)
          ..record(record, functionRecord)
          ..endRecordFile();

        expect(recorder.records().single.functions,
            containsPair(functionName, functionRecord));
      });
    });

    group('recordIssues', () {
      test('throws StateError if we call them in invalid state', () {
        expect(() {
          MetricsAnalysisRecorder().recordIssues([]);
        }, throwsStateError);
      });

      test('aggregate issues for component', () {
        const _issueRuleId = 'ruleId1';
        const _issueMessage = 'first issue message';
        const _issueCorrection = 'correction';
        const _issueCorrectionComment = 'correction comment';

        final recorder = MetricsAnalysisRecorder()
          ..startRecordFile(filePath, rootDirectory)
          ..recordIssues([
            CodeIssue(
              ruleId: _issueRuleId,
              severity: CodeIssueSeverity.style,
              sourceSpan: SourceSpanBase(
                  SourceLocation(1,
                      sourceUrl: Uri.parse(filePath), line: 2, column: 3),
                  SourceLocation(6, sourceUrl: Uri.parse(filePath)),
                  'issue'),
              message: _issueMessage,
              correction: _issueCorrection,
              correctionComment: _issueCorrectionComment,
            ),
          ])
          ..endRecordFile();

        expect(recorder.records().single.issues.single.ruleId, _issueRuleId);
        expect(recorder.records().single.issues.single.message, _issueMessage);
        expect(recorder.records().single.issues.single.correction,
            _issueCorrection);
        expect(recorder.records().single.issues.single.correctionComment,
            _issueCorrectionComment);
      });
    });
  });
}
