@TestOn('vm')
import 'package:analyzer/dart/ast/ast.dart';
import 'package:code_checker/checker.dart';
import 'package:code_checker/rules.dart';
import 'package:dart_code_metrics/src/obsoleted/metrics_analysis_recorder.dart';
import 'package:mockito/mockito.dart';
import 'package:source_span/source_span.dart';
import 'package:test/test.dart';

import 'stubs_builders.dart';

class ClassDeclarationMock extends Mock implements ClassDeclaration {}

class FunctionDeclarationMock extends Mock implements FunctionDeclaration {}

class SimpleIdentifierMock extends Mock implements SimpleIdentifier {}

void main() {
  group('MetricsAnalysisRecorder', () {
    const filePath = '/home/developer/work/project/example.dart';
    const rootDirectory = '/home/developer/work/project/';

    group('recordFile', () {
      test('throws ArgumentError if called without filePath', () {
        expect(
          () {
            MetricsAnalysisRecorder().recordFile(null, null, null);
          },
          throwsArgumentError,
        );
      });

      test('throws ArgumentError if called without function', () {
        expect(
          () {
            MetricsAnalysisRecorder().recordFile(filePath, rootDirectory, null);
          },
          throwsArgumentError,
        );
      });

      group('Stores component records for file', () {
        const componentName = 'simpleClass';

        final simpleIdentifierMock = SimpleIdentifierMock();
        when(simpleIdentifierMock.name).thenReturn(componentName);

        final classDeclarationMock = ClassDeclarationMock();
        when(classDeclarationMock.name).thenReturn(simpleIdentifierMock);

        final record =
            ScopedClassDeclaration(ClassType.generic, classDeclarationMock);

        test('throws ArgumentError if called without record', () {
          expect(
            () {
              MetricsAnalysisRecorder().recordFile(
                filePath,
                rootDirectory,
                (b) {
                  b.recordClass(null, null);
                },
              );
            },
            throwsArgumentError,
          );
        });

        test('Stores record for file', () {
          final componentRecord = buildComponentRecordStub();

          expect(
            MetricsAnalysisRecorder()
                .recordFile(filePath, rootDirectory, (b) {
                  b.recordClass(record, componentRecord);
                })
                .records()
                .single
                .components,
            containsPair(componentName, componentRecord),
          );
        });
      });

      group('Stores function records for file', () {
        const functionName = 'simpleFunction';

        final simpleIdentifierMock = SimpleIdentifierMock();
        when(simpleIdentifierMock.name).thenReturn(functionName);

        final functionDeclarationMock = FunctionDeclarationMock();
        when(functionDeclarationMock.name).thenReturn(simpleIdentifierMock);

        final record = ScopedFunctionDeclaration(
          FunctionType.function,
          functionDeclarationMock,
          null,
        );

        test('throws ArgumentError if called without record', () {
          expect(
            () {
              MetricsAnalysisRecorder().recordFile(
                filePath,
                rootDirectory,
                (b) {
                  b.recordFunctionData(null, null);
                },
              );
            },
            throwsArgumentError,
          );
        });

        test('Stores record for file', () {
          final functionRecord = buildFunctionRecordStub(
            location: SourceSpanBase(
              SourceLocation(0, line: 1),
              SourceLocation(0, line: 2),
              '',
            ),
            argumentsCount: 3,
          );

          expect(
            MetricsAnalysisRecorder()
                .recordFile(filePath, rootDirectory, (b) {
                  b.recordFunctionData(record, functionRecord);
                })
                .records()
                .single
                .functions,
            containsPair(functionName, functionRecord),
          );
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
                  Issue(
                    ruleId: _issueRuleId,
                    documentation: Uri.parse(_issueRuleDocumentation),
                    severity: Severity.style,
                    location: SourceSpanBase(
                      SourceLocation(
                        1,
                        sourceUrl: Uri.parse(filePath),
                        line: 2,
                        column: 3,
                      ),
                      SourceLocation(6, sourceUrl: Uri.parse(filePath)),
                      'issue',
                    ),
                    message: _issueMessage,
                    suggestion: const Replacement(
                      comment: _issueCorrectionComment,
                      replacement: _issueCorrection,
                    ),
                  ),
                ]);
              })
              .records()
              .single
              .issues
              .single;

          expect(issueRecord.ruleId, _issueRuleId);
          expect(
            issueRecord.documentation.toString(),
            _issueRuleDocumentation,
          );
          expect(issueRecord.message, _issueMessage);
          expect(issueRecord.suggestion.comment, _issueCorrectionComment);
          expect(issueRecord.suggestion.replacement, _issueCorrection);
        });
      });
    });

    group('recordComponent', () {
      const componentName = 'simpleClass';

      final simpleIdentifierMock = SimpleIdentifierMock();
      when(simpleIdentifierMock.name).thenReturn(componentName);

      final classDeclarationMock = ClassDeclarationMock();
      when(classDeclarationMock.name).thenReturn(simpleIdentifierMock);

      final record =
          ScopedClassDeclaration(ClassType.generic, classDeclarationMock);

      test('throws StateError if we call them in invalid state', () {
        expect(
          () {
            MetricsAnalysisRecorder().recordClass(record, null);
          },
          throwsStateError,
        );
      });

      test('throws ArgumentError if we call them without record', () {
        expect(
          () {
            MetricsAnalysisRecorder().recordFile(
              filePath,
              rootDirectory,
              (recorder) {
                recorder.recordClass(null, null);
              },
            );
          },
          throwsArgumentError,
        );
      });

      test('store record for file', () {
        final componentRecord = buildComponentRecordStub();

        final recorder = MetricsAnalysisRecorder()
            .recordFile(filePath, rootDirectory, (recorder) {
          recorder.recordClass(record, componentRecord);
        });

        expect(
          recorder.records().single.components,
          containsPair(componentName, componentRecord),
        );
      });
    });

    group('recordFunction', () {
      const functionName = 'simpleFunction';

      final simpleIdentifierMock = SimpleIdentifierMock();
      when(simpleIdentifierMock.name).thenReturn(functionName);

      final functionDeclarationMock = FunctionDeclarationMock();
      when(functionDeclarationMock.name).thenReturn(simpleIdentifierMock);

      final record = ScopedFunctionDeclaration(
        FunctionType.function,
        functionDeclarationMock,
        null,
      );

      test('throws StateError if we call them in invalid state', () {
        expect(
          () {
            MetricsAnalysisRecorder().recordFunctionData(record, null);
          },
          throwsStateError,
        );
      });

      test('throws ArgumentError if we call them without record', () {
        expect(
          () {
            MetricsAnalysisRecorder().recordFile(
              filePath,
              rootDirectory,
              (recorder) {
                recorder.recordFunctionData(null, null);
              },
            );
          },
          throwsArgumentError,
        );
      });

      test('store record for file', () {
        final functionRecord = buildFunctionRecordStub(
          location: SourceSpanBase(
            SourceLocation(0, line: 1),
            SourceLocation(0, line: 2),
            '',
          ),
          argumentsCount: 3,
        );

        final recorder = MetricsAnalysisRecorder()
            .recordFile(filePath, rootDirectory, (recorder) {
          recorder.recordFunctionData(record, functionRecord);
        });

        expect(
          recorder.records().single.functions,
          containsPair(functionName, functionRecord),
        );
      });
    });

    group('recordDesignIssues', () {
      test('throws StateError if we call them in invalid state', () {
        expect(
          () {
            MetricsAnalysisRecorder().recordAntiPatternCases([]);
          },
          throwsStateError,
        );
      });

      test('aggregate issues for file', () {
        const _issuePatternId = 'patternId1';
        const _issuePatternDocumentation = 'https://docu.edu/patternId1.html';
        const _issueMessage = 'first pattern message';
        const _issueRecommendation = 'recommendation';

        final recorder = MetricsAnalysisRecorder()
            .recordFile(filePath, rootDirectory, (recorder) {
          recorder.recordAntiPatternCases([
            Issue(
              ruleId: _issuePatternId,
              documentation: Uri.parse(_issuePatternDocumentation),
              location: SourceSpanBase(
                SourceLocation(
                  1,
                  sourceUrl: Uri.parse(filePath),
                  line: 2,
                  column: 3,
                ),
                SourceLocation(6, sourceUrl: Uri.parse(filePath)),
                'issue',
              ),
              severity: Severity.none,
              message: _issueMessage,
              verboseMessage: _issueRecommendation,
            ),
          ]);
        });

        final issue = recorder.records().single.designIssues.single;
        expect(issue.ruleId, _issuePatternId);
        expect(
          issue.documentation.toString(),
          _issuePatternDocumentation,
        );
        expect(issue.message, _issueMessage);
        expect(issue.verboseMessage, _issueRecommendation);
      });
    });

    group('recordIssues', () {
      test('throws StateError if we call them in invalid state', () {
        expect(
          () {
            MetricsAnalysisRecorder().recordIssues([]);
          },
          throwsStateError,
        );
      });

      test('aggregate issues for file', () {
        const _issueRuleId = 'ruleId1';
        const _issueRuleDocumentation = 'https://docu.edu/ruleId1.html';
        const _issueMessage = 'first issue message';
        const _issueCorrection = 'correction';
        const _issueCorrectionComment = 'correction comment';

        final recorder = MetricsAnalysisRecorder()
            .recordFile(filePath, rootDirectory, (recorder) {
          recorder.recordIssues([
            Issue(
              ruleId: _issueRuleId,
              documentation: Uri.parse(_issueRuleDocumentation),
              severity: Severity.style,
              location: SourceSpanBase(
                SourceLocation(
                  1,
                  sourceUrl: Uri.parse(filePath),
                  line: 2,
                  column: 3,
                ),
                SourceLocation(6, sourceUrl: Uri.parse(filePath)),
                'issue',
              ),
              message: _issueMessage,
              suggestion: const Replacement(
                comment: _issueCorrectionComment,
                replacement: _issueCorrection,
              ),
            ),
          ]);
        });

        final issue = recorder.records().single.issues.single;
        expect(issue.ruleId, _issueRuleId);
        expect(issue.documentation.toString(), _issueRuleDocumentation);
        expect(issue.message, _issueMessage);
        expect(issue.suggestion.comment, _issueCorrectionComment);
        expect(issue.suggestion.replacement, _issueCorrection);
      });
    });
  });
}
