@TestOn('vm')
// ignore_for_file: deprecated_member_use_from_same_package
import 'package:analyzer/dart/ast/ast.dart';
import 'package:dart_code_metrics/src/metrics_analysis_recorder.dart';
import 'package:dart_code_metrics/src/models/code_issue.dart';
import 'package:dart_code_metrics/src/models/code_issue_severity.dart';
import 'package:dart_code_metrics/src/models/component_record.dart';
import 'package:dart_code_metrics/src/models/function_record.dart';
import 'package:dart_code_metrics/src/models/scoped_component_declaration.dart';
import 'package:dart_code_metrics/src/models/scoped_function_declaration.dart';
import 'package:mockito/mockito.dart';
import 'package:source_span/source_span.dart';
import 'package:test/test.dart';

class ClassDeclarationMock extends Mock implements ClassDeclaration {}

class FunctionDeclarationMock extends Mock implements FunctionDeclaration {}

class SimpleIdentifierMock extends Mock implements SimpleIdentifier {}

void main() {
  group('MetricsAnalysisRecorder', () {
    const filePath = '/home/developer/work/project/example.dart';
    const rootDirectory = '/home/developer/work/project/';

    group('recordFile', () {
      test('throws ArgumentError if called without filePath', () {
        expect(() {
          MetricsAnalysisRecorder().recordFile(null, null, null);
        }, throwsArgumentError);
      });

      test('throws ArgumentError if called without function', () {
        expect(() {
          MetricsAnalysisRecorder().recordFile(filePath, rootDirectory, null);
        }, throwsArgumentError);
      });

      group('Stores component records for file', () {
        const componentName = 'simpleClass';

        final simpleIdentifierMock = SimpleIdentifierMock();
        when(simpleIdentifierMock.name).thenReturn(componentName);

        final classDeclarationMock = ClassDeclarationMock();
        when(classDeclarationMock.name).thenReturn(simpleIdentifierMock);

        final record = ScopedComponentDeclaration(classDeclarationMock);

        test('throws ArgumentError if called without record', () {
          expect(() {
            MetricsAnalysisRecorder().recordFile(filePath, rootDirectory, (b) {
              b.recordComponent(null, null);
            });
          }, throwsArgumentError);
        });

        test('Stores record for file', () {
          const componentRecord =
              ComponentRecord(firstLine: 1, lastLine: 2, methodsCount: 3);

          expect(
              MetricsAnalysisRecorder()
                  .recordFile(filePath, rootDirectory, (b) {
                    b.recordComponent(record, componentRecord);
                  })
                  .records()
                  .single
                  .components,
              containsPair(componentName, componentRecord));
        });
      });

      group('Stores function records for file', () {
        const functionName = 'simpleFunction';

        final simpleIdentifierMock = SimpleIdentifierMock();
        when(simpleIdentifierMock.name).thenReturn(functionName);

        final functionDeclarationMock = FunctionDeclarationMock();
        when(functionDeclarationMock.name).thenReturn(simpleIdentifierMock);

        final record = ScopedFunctionDeclaration(functionDeclarationMock, null);

        test('throws ArgumentError if called without record', () {
          expect(() {
            MetricsAnalysisRecorder().recordFile(filePath, rootDirectory, (b) {
              b.recordFunction(null, null);
            });
          }, throwsArgumentError);
        });

        test('Stores record for file', () {
          const functionRecord = FunctionRecord(
            firstLine: 1,
            lastLine: 2,
            argumentsCount: 3,
            cyclomaticComplexityLines: {},
            linesWithCode: [],
            operators: {},
            operands: {},
          );

          expect(
              MetricsAnalysisRecorder()
                  .recordFile(filePath, rootDirectory, (b) {
                    b.recordFunction(record, functionRecord);
                  })
                  .records()
                  .single
                  .functions,
              containsPair(functionName, functionRecord));
        });
      });
      group('Stores issues for file', () {
        test('Aggregates issues for file', () {
          const _issueRuleId = 'ruleId1';
          const _issueRuleDocumentation = 'https://docu.edu/ruleId1.html';
          const _issueMessage = 'first issue message';
          const _issueCorrection = 'correction';
          const _issueCorrectionComment = 'correction comment';

          final issueRecord = MetricsAnalysisRecorder()
              .recordFile(filePath, rootDirectory, (b) {
                b.recordIssues([
                  CodeIssue(
                    ruleId: _issueRuleId,
                    ruleDocumentation: Uri.parse(_issueRuleDocumentation),
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
                ]);
              })
              .records()
              .single
              .issues
              .single;

          expect(issueRecord.ruleId, _issueRuleId);
          expect(issueRecord.ruleDocumentation.toString(),
              _issueRuleDocumentation);
          expect(issueRecord.message, _issueMessage);
          expect(issueRecord.correction, _issueCorrection);
          expect(issueRecord.correctionComment, _issueCorrectionComment);
        });
      });
    });

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

    group('recordComponent', () {
      const componentName = 'simpleClass';

      final simpleIdentifierMock = SimpleIdentifierMock();
      when(simpleIdentifierMock.name).thenReturn(componentName);

      final classDeclarationMock = ClassDeclarationMock();
      when(classDeclarationMock.name).thenReturn(simpleIdentifierMock);

      final record = ScopedComponentDeclaration(classDeclarationMock);

      test('throws StateError if we call them in invalid state', () {
        expect(() {
          MetricsAnalysisRecorder().recordComponent(record, null);
        }, throwsStateError);
      });

      test('throws ArgumentError if we call them without record', () {
        expect(() {
          MetricsAnalysisRecorder()
            ..startRecordFile(filePath, rootDirectory)
            ..recordComponent(null, null);
        }, throwsArgumentError);
      });

      test('store record for file', () {
        const componentRecord =
            ComponentRecord(firstLine: 1, lastLine: 2, methodsCount: 3);

        final recorder = MetricsAnalysisRecorder()
          ..startRecordFile(filePath, rootDirectory)
          ..recordComponent(record, componentRecord)
          ..endRecordFile();

        expect(recorder.records().single.components,
            containsPair(componentName, componentRecord));
      });
    });

    group('recordFunction', () {
      const functionName = 'simpleFunction';

      final simpleIdentifierMock = SimpleIdentifierMock();
      when(simpleIdentifierMock.name).thenReturn(functionName);

      final functionDeclarationMock = FunctionDeclarationMock();
      when(functionDeclarationMock.name).thenReturn(simpleIdentifierMock);

      final record = ScopedFunctionDeclaration(functionDeclarationMock, null);

      test('throws StateError if we call them in invalid state', () {
        expect(() {
          MetricsAnalysisRecorder().recordFunction(record, null);
        }, throwsStateError);
      });

      test('throws ArgumentError if we call them without record', () {
        expect(() {
          MetricsAnalysisRecorder()
            ..startRecordFile(filePath, rootDirectory)
            ..recordFunction(null, null);
        }, throwsArgumentError);
      });

      test('store record for file', () {
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
          ..recordFunction(record, functionRecord)
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

      test('aggregate issues for file', () {
        const _issueRuleId = 'ruleId1';
        const _issueRuleDocumentation = 'https://docu.edu/ruleId1.html';
        const _issueMessage = 'first issue message';
        const _issueCorrection = 'correction';
        const _issueCorrectionComment = 'correction comment';

        final recorder = MetricsAnalysisRecorder()
          ..startRecordFile(filePath, rootDirectory)
          ..recordIssues([
            CodeIssue(
              ruleId: _issueRuleId,
              ruleDocumentation: Uri.parse(_issueRuleDocumentation),
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

        final issue = recorder.records().single.issues.single;
        expect(issue.ruleId, _issueRuleId);
        expect(issue.ruleDocumentation.toString(), _issueRuleDocumentation);
        expect(issue.message, _issueMessage);
        expect(issue.correction, _issueCorrection);
        expect(issue.correctionComment, _issueCorrectionComment);
      });
    });
  });
}
