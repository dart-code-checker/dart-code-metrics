@TestOn('vm')
import 'dart:convert';

import 'package:dart_code_metrics/src/config/config.dart';
import 'package:dart_code_metrics/src/models/code_issue.dart';
import 'package:dart_code_metrics/src/models/code_issue_severity.dart';
import 'package:dart_code_metrics/src/models/component_record.dart';
import 'package:dart_code_metrics/src/models/design_issue.dart';
import 'package:dart_code_metrics/src/models/file_record.dart';
import 'package:dart_code_metrics/src/models/function_record.dart';
import 'package:dart_code_metrics/src/reporters/json_reporter.dart';
import 'package:source_span/source_span.dart';
import 'package:test/test.dart';

import '../stubs_builders.dart';

void main() {
  group('JsonReporter.report report about', () {
    const fullPath = '/home/developer/work/project/example.darts';

    JsonReporter _reporter;

    setUp(() {
      _reporter = JsonReporter(reportConfig: const Config());
    });

    test('empty file', () {
      expect(_reporter.report([]), isEmpty);
    });

    group('file', () {
      test('aggregated arguments metric values', () {
        final records = [
          FileRecord(
            fullPath: fullPath,
            relativePath: 'example.dart',
            components: Map.unmodifiable(<String, ComponentRecord>{
              'class': buildComponentRecordStub(methodsCount: 25),
              'mixin': buildComponentRecordStub(methodsCount: 15),
              'extension': buildComponentRecordStub(methodsCount: 0),
            }),
            functions: Map.unmodifiable(<String, FunctionRecord>{
              'function':
                  buildFunctionRecordStub(argumentsCount: 0, nestingLines: []),
              'function2':
                  buildFunctionRecordStub(argumentsCount: 6, nestingLines: [
                [1, 2],
              ]),
              'function3':
                  buildFunctionRecordStub(argumentsCount: 10, nestingLines: [
                [1, 2],
                [3],
                [4, 5, 6, 7, 8, 9, 10],
              ]),
            }),
            issues: const [],
            designIssues: const [],
          ),
        ];

        final report =
            (json.decode(_reporter.report(records).first) as List<Object>).first
                as Map<String, Object>;

        expect(report, containsPair('average-number-of-arguments', 5));
        expect(report, containsPair('total-number-of-arguments-violations', 2));
        expect(report, containsPair('average-number-of-methods', 13));
        expect(report, containsPair('total-number-of-methods-violations', 2));
        expect(report, containsPair('average-maximum-nesting', 3));
        expect(report, containsPair('total-maximum-nesting-violations', 1));
      });

      test('with design issues', () {
        const _issuePatternId = 'patternId1';
        const _issuePatternDocumentation = 'https://docu.edu/patternId1.html';
        const _issueLine = 2;
        const _issueColumn = 3;
        const _issueProblemCode = 'issue';
        const _issueMessage = 'first issue message';
        const _issueRecommendation = 'issue recommendation';

        final records = [
          FileRecord(
            fullPath: fullPath,
            relativePath: 'example.dart',
            components: Map.unmodifiable(<String, ComponentRecord>{}),
            functions: Map.unmodifiable(<String, FunctionRecord>{}),
            issues: const [],
            designIssues: [
              DesignIssue(
                patternId: _issuePatternId,
                patternDocumentation: Uri.parse(_issuePatternDocumentation),
                sourceSpan: SourceSpanBase(
                  SourceLocation(
                    1,
                    sourceUrl: Uri.parse(fullPath),
                    line: _issueLine,
                    column: _issueColumn,
                  ),
                  SourceLocation(6, sourceUrl: Uri.parse(fullPath)),
                  _issueProblemCode,
                ),
                message: _issueMessage,
                recommendation: _issueRecommendation,
              ),
            ],
          ),
        ];

        final report =
            (json.decode(_reporter.report(records).first) as List<Object>).first
                as Map<String, Object>;

        expect(report.containsKey('designIssues'), isTrue);

        final issue = (report['designIssues'] as List<Object>)
            .cast<Map<String, Object>>()
            .single;

        expect(issue, containsPair('patternId', _issuePatternId));
        expect(issue,
            containsPair('patternDocumentation', _issuePatternDocumentation));
        expect(issue, containsPair('lineNumber', _issueLine));
        expect(issue, containsPair('columnNumber', _issueColumn));
        expect(issue, containsPair('problemCode', _issueProblemCode));
        expect(issue, containsPair('message', _issueMessage));
        expect(issue, containsPair('recommendation', _issueRecommendation));
      });

      test('with style severity issues', () {
        const _issueRuleId = 'ruleId1';
        const _issueRuleDocumentation = 'https://docu.edu/ruleId1.html';
        const _issueLine = 2;
        const _issueColumn = 3;
        const _issueProblemCode = 'issue';
        const _issueMessage = 'first issue message';
        const _issueCorrection = 'issue correction';
        const _issueCorrectionComment = 'correction comment';

        final records = [
          FileRecord(
            fullPath: fullPath,
            relativePath: 'example.dart',
            components: Map.unmodifiable(<String, ComponentRecord>{}),
            functions: Map.unmodifiable(<String, FunctionRecord>{}),
            issues: [
              CodeIssue(
                ruleId: _issueRuleId,
                ruleDocumentation: Uri.parse(_issueRuleDocumentation),
                severity: CodeIssueSeverity.style,
                sourceSpan: SourceSpanBase(
                  SourceLocation(
                    1,
                    sourceUrl: Uri.parse(fullPath),
                    line: _issueLine,
                    column: _issueColumn,
                  ),
                  SourceLocation(6, sourceUrl: Uri.parse(fullPath)),
                  _issueProblemCode,
                ),
                message: _issueMessage,
                correction: _issueCorrection,
                correctionComment: _issueCorrectionComment,
              ),
            ],
            designIssues: const [],
          ),
        ];

        final report =
            (json.decode(_reporter.report(records).first) as List<Object>).first
                as Map<String, Object>;

        expect(report.containsKey('issues'), isTrue);

        final issue = (report['issues'] as List<Object>)
            .cast<Map<String, Object>>()
            .single;

        expect(issue, containsPair('severity', 'style'));
        expect(issue, containsPair('ruleId', _issueRuleId));
        expect(
            issue, containsPair('ruleDocumentation', _issueRuleDocumentation));
        expect(issue, containsPair('lineNumber', _issueLine));
        expect(issue, containsPair('columnNumber', _issueColumn));
        expect(issue, containsPair('problemCode', _issueProblemCode));
        expect(issue, containsPair('message', _issueMessage));
        expect(issue, containsPair('correction', _issueCorrection));
        expect(
          issue,
          containsPair('correctionComment', _issueCorrectionComment),
        );
      });
    });

    group('component', () {
      test('without methods', () {
        final records = [
          FileRecord(
            fullPath: fullPath,
            relativePath: 'example.dart',
            components: Map.unmodifiable(<String, ComponentRecord>{
              'class': buildComponentRecordStub(methodsCount: 0),
            }),
            functions: Map.unmodifiable(<String, FunctionRecord>{}),
            issues: const [],
            designIssues: const [],
          ),
        ];

        final report =
            (json.decode(_reporter.report(records).first) as List<Object>).first
                as Map<String, Object>;
        final functionReport = (report['records']
            as Map<String, Object>)['class'] as Map<String, Object>;

        expect(functionReport, containsPair('number-of-methods', 0));
        expect(
          functionReport,
          containsPair('number-of-methods-violation-level', 'none'),
        );
      });

      test('with a lot of methods', () {
        final records = [
          FileRecord(
            fullPath: fullPath,
            relativePath: 'example.dart',
            components: Map.unmodifiable(<String, ComponentRecord>{
              'class': buildComponentRecordStub(methodsCount: 20),
            }),
            functions: Map.unmodifiable(<String, FunctionRecord>{}),
            issues: const [],
            designIssues: const [],
          ),
        ];

        final report =
            (json.decode(_reporter.report(records).first) as List<Object>).first
                as Map<String, Object>;
        final functionReport = (report['records']
            as Map<String, Object>)['class'] as Map<String, Object>;

        expect(functionReport, containsPair('number-of-methods', 20));
        expect(
          functionReport,
          containsPair('number-of-methods-violation-level', 'warning'),
        );
      });
    });

    group('function', () {
      test('with long body', () {
        final records = [
          FileRecord(
            fullPath: fullPath,
            relativePath: 'example.dart',
            components: Map.unmodifiable(<String, ComponentRecord>{}),
            functions: Map.unmodifiable(<String, FunctionRecord>{
              'function': buildFunctionRecordStub(
                  linesWithCode: List.generate(150, (index) => index)),
            }),
            issues: const [],
            designIssues: const [],
          ),
        ];

        final report =
            (json.decode(_reporter.report(records).first) as List<Object>).first
                as Map<String, Object>;
        final functionReport = (report['records']
            as Map<String, Object>)['function'] as Map<String, Object>;

        expect(functionReport, containsPair('lines-of-executable-code', 150));
        expect(
          functionReport,
          containsPair('lines-of-executable-code-violation-level', 'alarm'),
        );
      });

      test('with short body', () {
        final records = [
          FileRecord(
            fullPath: fullPath,
            relativePath: 'example.dart',
            components: Map.unmodifiable(<String, ComponentRecord>{}),
            functions: Map.unmodifiable(<String, FunctionRecord>{
              'function': buildFunctionRecordStub(
                  linesWithCode: List.generate(5, (index) => index)),
            }),
            issues: const [],
            designIssues: const [],
          ),
        ];

        final report =
            (json.decode(_reporter.report(records).first) as List<Object>).first
                as Map<String, Object>;
        final functionReport = (report['records']
            as Map<String, Object>)['function'] as Map<String, Object>;

        expect(functionReport, containsPair('lines-of-executable-code', 5));
        expect(
          functionReport,
          containsPair('lines-of-executable-code-violation-level', 'none'),
        );
      });

      test('without arguments', () {
        final records = [
          FileRecord(
            fullPath: fullPath,
            relativePath: 'example.dart',
            components: Map.unmodifiable(<String, ComponentRecord>{}),
            functions: Map.unmodifiable(<String, FunctionRecord>{
              'function': buildFunctionRecordStub(argumentsCount: 0),
            }),
            issues: const [],
            designIssues: const [],
          ),
        ];

        final report =
            (json.decode(_reporter.report(records).first) as List<Object>).first
                as Map<String, Object>;
        final functionReport = (report['records']
            as Map<String, Object>)['function'] as Map<String, Object>;

        expect(functionReport, containsPair('number-of-arguments', 0));
        expect(
          functionReport,
          containsPair('number-of-arguments-violation-level', 'none'),
        );
      });

      test('with a lot of arguments', () {
        final records = [
          FileRecord(
            fullPath: fullPath,
            relativePath: 'example.dart',
            components: Map.unmodifiable(<String, ComponentRecord>{}),
            functions: Map.unmodifiable(<String, FunctionRecord>{
              'function': buildFunctionRecordStub(argumentsCount: 10),
            }),
            issues: const [],
            designIssues: const [],
          ),
        ];

        final report =
            (json.decode(_reporter.report(records).first) as List<Object>).first
                as Map<String, Object>;
        final functionReport = (report['records']
            as Map<String, Object>)['function'] as Map<String, Object>;

        expect(functionReport, containsPair('number-of-arguments', 10));
        expect(
          functionReport,
          containsPair('number-of-arguments-violation-level', 'alarm'),
        );
      });

      test('with low nested level', () {
        final records = [
          FileRecord(
            fullPath: fullPath,
            relativePath: 'example.dart',
            components: Map.unmodifiable(<String, ComponentRecord>{}),
            functions: Map.unmodifiable(<String, FunctionRecord>{
              'function': buildFunctionRecordStub(nestingLines: [
                [1, 2],
              ]),
            }),
            issues: const [],
            designIssues: const [],
          ),
        ];

        final report =
            (json.decode(_reporter.report(records).first) as List<Object>).first
                as Map<String, Object>;
        final functionReport = (report['records']
            as Map<String, Object>)['function'] as Map<String, Object>;

        expect(functionReport, containsPair('maximum-nesting', 2));
        expect(
          functionReport,
          containsPair('maximum-nesting-violation-level', 'none'),
        );
      });

      test('with high nested level', () {
        final records = [
          FileRecord(
            fullPath: fullPath,
            relativePath: 'example.dart',
            components: Map.unmodifiable(<String, ComponentRecord>{}),
            functions: Map.unmodifiable(<String, FunctionRecord>{
              'function': buildFunctionRecordStub(nestingLines: [
                [1, 2],
                [3],
                [4, 5, 6, 7, 8, 9, 10],
              ]),
            }),
            issues: const [],
            designIssues: const [],
          ),
        ];

        final report =
            (json.decode(_reporter.report(records).first) as List<Object>).first
                as Map<String, Object>;
        final functionReport = (report['records']
            as Map<String, Object>)['function'] as Map<String, Object>;

        expect(functionReport, containsPair('maximum-nesting', 7));
        expect(
          functionReport,
          containsPair('maximum-nesting-violation-level', 'warning'),
        );
      });
    });
  });
}
