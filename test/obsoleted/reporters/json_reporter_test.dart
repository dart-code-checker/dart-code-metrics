@TestOn('vm')
import 'dart:convert';

import 'package:code_checker/checker.dart';
import 'package:code_checker/metrics.dart';
import 'package:code_checker/rules.dart';
import 'package:dart_code_metrics/src/obsoleted/config/config.dart' as metrics;
import 'package:dart_code_metrics/src/obsoleted/models/file_record.dart';
import 'package:dart_code_metrics/src/obsoleted/models/function_record.dart';
import 'package:dart_code_metrics/src/obsoleted/reporters/json_reporter.dart';
import 'package:source_span/source_span.dart';
import 'package:test/test.dart';

import '../stubs_builders.dart';

void main() {
  group('JsonReporter.report report about', () {
    const fullPath = '/home/developer/work/project/example.darts';

    JsonReporter _reporter;

    setUp(() {
      _reporter = JsonReporter(reportConfig: const metrics.Config());
    });

    test('empty file', () async {
      expect(await _reporter.report([]), isEmpty);
    });

    group('file', () {
      test('aggregated arguments metric values', () async {
        final records = [
          FileRecord(
            fullPath: fullPath,
            relativePath: 'example.dart',
            components: Map.unmodifiable(<String, Report>{
              'class': buildComponentRecordStub(metrics: const [
                MetricValue<int>(
                  metricsId: NumberOfMethodsMetric.metricId,
                  value: 25,
                  level: MetricValueLevel.alarm,
                  comment: '',
                ),
              ]),
              'mixin': buildComponentRecordStub(metrics: const [
                MetricValue<int>(
                  metricsId: NumberOfMethodsMetric.metricId,
                  value: 15,
                  level: MetricValueLevel.warning,
                  comment: '',
                ),
              ]),
              'extension': buildComponentRecordStub(metrics: const [
                MetricValue<int>(
                  metricsId: NumberOfMethodsMetric.metricId,
                  value: 0,
                  level: MetricValueLevel.none,
                  comment: '',
                ),
              ]),
            }),
            functions: Map.unmodifiable(<String, FunctionRecord>{
              'function': buildFunctionRecordStub(argumentsCount: 0),
              'function2': buildFunctionRecordStub(
                argumentsCount: 6,
                metrics: const [
                  MetricValue<int>(
                    metricsId: MaximumNestingLevelMetric.metricId,
                    value: 2,
                    level: MetricValueLevel.none,
                    comment: '',
                  ),
                ],
              ),
              'function3': buildFunctionRecordStub(
                argumentsCount: 10,
                metrics: const [
                  MetricValue<int>(
                    metricsId: MaximumNestingLevelMetric.metricId,
                    value: 6,
                    level: MetricValueLevel.warning,
                    comment: '',
                  ),
                ],
              ),
            }),
            issues: const [],
            designIssues: const [],
          ),
        ];

        final report = (json.decode((await _reporter.report(records)).first)
                as List<Object>)
            .first as Map<String, Object>;

        expect(report, containsPair('average-number-of-arguments', 5));
        expect(report, containsPair('total-number-of-arguments-violations', 2));
        expect(report, containsPair('average-number-of-methods', 13));
        expect(report, containsPair('total-number-of-methods-violations', 2));
        expect(report, containsPair('average-maximum-nesting', 3));
        expect(report, containsPair('total-maximum-nesting-violations', 1));
      });

      test('with design issues', () async {
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
            components: Map.unmodifiable(<String, Report>{}),
            functions: Map.unmodifiable(<String, FunctionRecord>{}),
            issues: const [],
            designIssues: [
              Issue(
                ruleId: _issuePatternId,
                documentation: Uri.parse(_issuePatternDocumentation),
                location: SourceSpanBase(
                  SourceLocation(
                    1,
                    sourceUrl: Uri.parse(fullPath),
                    line: _issueLine,
                    column: _issueColumn,
                  ),
                  SourceLocation(6, sourceUrl: Uri.parse(fullPath)),
                  _issueProblemCode,
                ),
                severity: Severity.none,
                message: _issueMessage,
                verboseMessage: _issueRecommendation,
              ),
            ],
          ),
        ];

        final report = (json.decode((await _reporter.report(records)).first)
                as List<Object>)
            .first as Map<String, Object>;

        expect(report.containsKey('designIssues'), isTrue);

        final issue = (report['designIssues'] as List<Object>)
            .cast<Map<String, Object>>()
            .single;

        expect(issue, containsPair('patternId', _issuePatternId));
        expect(
          issue,
          containsPair('patternDocumentation', _issuePatternDocumentation),
        );
        expect(issue, containsPair('lineNumber', _issueLine));
        expect(issue, containsPair('columnNumber', _issueColumn));
        expect(issue, containsPair('problemCode', _issueProblemCode));
        expect(issue, containsPair('message', _issueMessage));
        expect(issue, containsPair('recommendation', _issueRecommendation));
      });

      test('with style severity issues', () async {
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
            components: Map.unmodifiable(<String, Report>{}),
            functions: Map.unmodifiable(<String, FunctionRecord>{}),
            issues: [
              Issue(
                ruleId: _issueRuleId,
                documentation: Uri.parse(_issueRuleDocumentation),
                severity: Severity.style,
                location: SourceSpanBase(
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
                suggestion: const Replacement(
                  comment: _issueCorrectionComment,
                  replacement: _issueCorrection,
                ),
              ),
            ],
            designIssues: const [],
          ),
        ];

        final report = (json.decode((await _reporter.report(records)).first)
                as List<Object>)
            .first as Map<String, Object>;

        expect(report.containsKey('issues'), isTrue);

        final issue = (report['issues'] as List<Object>)
            .cast<Map<String, Object>>()
            .single;

        expect(issue, containsPair('severity', 'style'));
        expect(issue, containsPair('ruleId', _issueRuleId));
        expect(
          issue,
          containsPair('ruleDocumentation', _issueRuleDocumentation),
        );
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
      test('without methods', () async {
        final records = [
          FileRecord(
            fullPath: fullPath,
            relativePath: 'example.dart',
            components: Map.unmodifiable(<String, Report>{
              'class': buildComponentRecordStub(metrics: const [
                MetricValue<int>(
                  metricsId: NumberOfMethodsMetric.metricId,
                  value: 0,
                  level: MetricValueLevel.none,
                  comment: '',
                ),
              ]),
            }),
            functions: Map.unmodifiable(<String, FunctionRecord>{}),
            issues: const [],
            designIssues: const [],
          ),
        ];

        final report = (json.decode((await _reporter.report(records)).first)
                as List<Object>)
            .first as Map<String, Object>;
        final functionReport = (report['records']
            as Map<String, Object>)['class'] as Map<String, Object>;

        expect(functionReport, containsPair('number-of-methods', 0));
        expect(
          functionReport,
          containsPair('number-of-methods-violation-level', 'none'),
        );
      });

      test('with a lot of methods', () async {
        final records = [
          FileRecord(
            fullPath: fullPath,
            relativePath: 'example.dart',
            components: Map.unmodifiable(<String, Report>{
              'class': buildComponentRecordStub(metrics: const [
                MetricValue<int>(
                  metricsId: NumberOfMethodsMetric.metricId,
                  value: 20,
                  level: MetricValueLevel.warning,
                  comment: '',
                ),
              ]),
            }),
            functions: Map.unmodifiable(<String, FunctionRecord>{}),
            issues: const [],
            designIssues: const [],
          ),
        ];

        final report = (json.decode((await _reporter.report(records)).first)
                as List<Object>)
            .first as Map<String, Object>;
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
      test('with long body', () async {
        final records = [
          FileRecord(
            fullPath: fullPath,
            relativePath: 'example.dart',
            components: Map.unmodifiable(<String, Report>{}),
            functions: Map.unmodifiable(<String, FunctionRecord>{
              'function': buildFunctionRecordStub(
                linesWithCode: List.generate(150, (index) => index),
              ),
            }),
            issues: const [],
            designIssues: const [],
          ),
        ];

        final report = (json.decode((await _reporter.report(records)).first)
                as List<Object>)
            .first as Map<String, Object>;
        final functionReport = (report['records']
            as Map<String, Object>)['function'] as Map<String, Object>;

        expect(functionReport, containsPair('lines-of-executable-code', 150));
        expect(
          functionReport,
          containsPair('lines-of-executable-code-violation-level', 'alarm'),
        );
      });

      test('with short body', () async {
        final records = [
          FileRecord(
            fullPath: fullPath,
            relativePath: 'example.dart',
            components: Map.unmodifiable(<String, Report>{}),
            functions: Map.unmodifiable(<String, FunctionRecord>{
              'function': buildFunctionRecordStub(
                linesWithCode: List.generate(5, (index) => index),
              ),
            }),
            issues: const [],
            designIssues: const [],
          ),
        ];

        final report = (json.decode((await _reporter.report(records)).first)
                as List<Object>)
            .first as Map<String, Object>;
        final functionReport = (report['records']
            as Map<String, Object>)['function'] as Map<String, Object>;

        expect(functionReport, containsPair('lines-of-executable-code', 5));
        expect(
          functionReport,
          containsPair('lines-of-executable-code-violation-level', 'none'),
        );
      });

      test('without arguments', () async {
        final records = [
          FileRecord(
            fullPath: fullPath,
            relativePath: 'example.dart',
            components: Map.unmodifiable(<String, Report>{}),
            functions: Map.unmodifiable(<String, FunctionRecord>{
              'function': buildFunctionRecordStub(argumentsCount: 0),
            }),
            issues: const [],
            designIssues: const [],
          ),
        ];

        final report = (json.decode((await _reporter.report(records)).first)
                as List<Object>)
            .first as Map<String, Object>;
        final functionReport = (report['records']
            as Map<String, Object>)['function'] as Map<String, Object>;

        expect(functionReport, containsPair('number-of-arguments', 0));
        expect(
          functionReport,
          containsPair('number-of-arguments-violation-level', 'none'),
        );
      });

      test('with a lot of arguments', () async {
        final records = [
          FileRecord(
            fullPath: fullPath,
            relativePath: 'example.dart',
            components: Map.unmodifiable(<String, Report>{}),
            functions: Map.unmodifiable(<String, FunctionRecord>{
              'function': buildFunctionRecordStub(argumentsCount: 10),
            }),
            issues: const [],
            designIssues: const [],
          ),
        ];

        final report = (json.decode((await _reporter.report(records)).first)
                as List<Object>)
            .first as Map<String, Object>;
        final functionReport = (report['records']
            as Map<String, Object>)['function'] as Map<String, Object>;

        expect(functionReport, containsPair('number-of-arguments', 10));
        expect(
          functionReport,
          containsPair('number-of-arguments-violation-level', 'alarm'),
        );
      });

      test('with low nested level', () async {
        final records = [
          FileRecord(
            fullPath: fullPath,
            relativePath: 'example.dart',
            components: Map.unmodifiable(<String, Report>{}),
            functions: Map.unmodifiable(<String, FunctionRecord>{
              'function': buildFunctionRecordStub(
                metrics: const [
                  MetricValue<int>(
                    metricsId: MaximumNestingLevelMetric.metricId,
                    value: 2,
                    level: MetricValueLevel.none,
                    comment: '',
                  ),
                ],
              ),
            }),
            issues: const [],
            designIssues: const [],
          ),
        ];

        final report = (json.decode((await _reporter.report(records)).first)
                as List<Object>)
            .first as Map<String, Object>;
        final functionReport = (report['records']
            as Map<String, Object>)['function'] as Map<String, Object>;

        expect(functionReport, containsPair('maximum-nesting', 2));
        expect(
          functionReport,
          containsPair('maximum-nesting-violation-level', 'none'),
        );
      });

      test('with high nested level', () async {
        final records = [
          FileRecord(
            fullPath: fullPath,
            relativePath: 'example.dart',
            components: Map.unmodifiable(<String, Report>{}),
            functions: Map.unmodifiable(<String, FunctionRecord>{
              'function': buildFunctionRecordStub(
                metrics: const [
                  MetricValue<int>(
                    metricsId: MaximumNestingLevelMetric.metricId,
                    value: 7,
                    level: MetricValueLevel.warning,
                    comment: '',
                  ),
                ],
              ),
            }),
            issues: const [],
            designIssues: const [],
          ),
        ];

        final report = (json.decode((await _reporter.report(records)).first)
                as List<Object>)
            .first as Map<String, Object>;
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
