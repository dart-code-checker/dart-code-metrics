@TestOn('vm')
import 'dart:io';

import 'package:ansicolor/ansicolor.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/metrics_list/maximum_nesting_level/maximum_nesting_level_metric.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/metrics_list/number_of_methods_metric.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/metrics_list/number_of_parameters_metric.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/metrics_list/source_lines_of_code/source_lines_of_code_metric.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/models/metric_documentation.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/models/metric_value.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/models/metric_value_level.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/entity_type.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/issue.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/lint_file_report.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/replacement.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/report.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/reporters/reporters_list/console/lint_console_reporter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:source_span/source_span.dart';
import 'package:test/test.dart';

import '../../../../stubs_builders.dart';

class IOSinkMock extends Mock implements IOSink {}

void main() {
  group('LintConsoleReporter.report report about', () {
    late IOSinkMock output; // ignore: close_sinks
    late IOSinkMock verboseOutput; // ignore: close_sinks
    const fullPath = '/home/developer/work/project/example.dart';

    late LintConsoleReporter _reporter;
    late LintConsoleReporter _verboseReporter;

    setUp(() {
      output = IOSinkMock();
      verboseOutput = IOSinkMock();

      ansiColorDisabled = false;
      _reporter = LintConsoleReporter(output);
      _verboseReporter = LintConsoleReporter(verboseOutput, reportAll: true);
    });

    test('files without any records', () async {
      await _reporter.report([]);
      await _verboseReporter.report([]);

      verifyNever(() => output.writeln(any()));
      verifyNever(() => verboseOutput.writeln(any()));
    });

    group('component', () {
      test('without methods', () async {
        final records = [
          LintFileReport(
            path: fullPath,
            relativePath: 'example.dart',
            classes: Map.unmodifiable(<String, Report>{
              'class': buildRecordStub(metrics: const [
                MetricValue<int>(
                  metricsId: NumberOfMethodsMetric.metricId,
                  documentation: MetricDocumentation(
                    name: '',
                    shortName: '',
                    brief: '',
                    measuredType: EntityType.classEntity,
                    examples: [],
                  ),
                  value: 0,
                  level: MetricValueLevel.none,
                  comment: '',
                ),
              ]),
            }),
            functions: Map.unmodifiable(<String, Report>{}),
            issues: const [],
            antiPatternCases: const [],
          ),
        ];

        await _reporter.report(records);
        await _verboseReporter.report(records);

        verifyNever(() => output.writeln(any()));
        final verboseReport = verify(() => verboseOutput.writeln(captureAny()))
            .captured
            .cast<String>();
        expect(verboseReport, hasLength(3));
        expect(
          verboseReport[1],
          contains('number of methods: \x1B[38;5;7m0\x1B[0m'),
        );
      });

      test('with a lot of methods', () async {
        final records = [
          LintFileReport(
            path: fullPath,
            relativePath: 'example.dart',
            classes: Map.unmodifiable(<String, Report>{
              'class': buildRecordStub(metrics: const [
                MetricValue<int>(
                  metricsId: NumberOfMethodsMetric.metricId,
                  documentation: MetricDocumentation(
                    name: '',
                    shortName: '',
                    brief: '',
                    measuredType: EntityType.classEntity,
                    examples: [],
                  ),
                  value: 20,
                  level: MetricValueLevel.warning,
                  comment: '',
                ),
              ]),
            }),
            functions: Map.unmodifiable(<String, Report>{}),
            issues: const [],
            antiPatternCases: const [],
          ),
        ];

        await _reporter.report(records);

        final report =
            verify(() => output.writeln(captureAny())).captured.cast<String>();
        expect(report, hasLength(3));
        expect(report[1], contains('number of methods: \x1B[38;5;3m20\x1B[0m'));
      });
    });

    group('function', () {
      test('with long body', () async {
        final records = [
          LintFileReport(
            path: fullPath,
            relativePath: 'example.dart',
            classes: Map.unmodifiable(<String, Report>{}),
            functions: Map.unmodifiable(<String, Report>{
              'function': buildFunctionRecordStub(
                metrics: [
                  buildMetricValueStub<int>(
                    id: SourceLinesOfCodeMetric.metricId,
                    value: 150,
                    level: MetricValueLevel.alarm,
                  ),
                ],
              ),
            }),
            issues: const [],
            antiPatternCases: const [],
          ),
        ];

        await _reporter.report(records);

        final report =
            verify(() => output.writeln(captureAny())).captured.cast<String>();
        expect(report, hasLength(3));
        expect(
          report[1],
          contains('source lines of code: \x1B[38;5;1m150\x1B[0m'),
        );
      });

      test('with short body', () async {
        final records = [
          LintFileReport(
            path: fullPath,
            relativePath: 'example.dart',
            classes: Map.unmodifiable(<String, Report>{}),
            functions: Map.unmodifiable(<String, Report>{
              'function': buildFunctionRecordStub(
                metrics: [
                  buildMetricValueStub<int>(
                    id: SourceLinesOfCodeMetric.metricId,
                    value: 5,
                  ),
                ],
              ),
            }),
            issues: const [],
            antiPatternCases: const [],
          ),
        ];

        await _reporter.report(records);
        await _verboseReporter.report(records);

        verifyNever(() => output.writeln(any()));

        final verboseReport = verify(() => verboseOutput.writeln(captureAny()))
            .captured
            .cast<String>();
        expect(verboseReport, hasLength(3));
        expect(
          verboseReport[1],
          contains('source lines of code: \x1B[38;5;7m5\x1B[0m'),
        );
      });

      test('without arguments', () async {
        final records = [
          LintFileReport(
            path: fullPath,
            relativePath: 'example.dart',
            classes: Map.unmodifiable(<String, Report>{}),
            functions: Map.unmodifiable(<String, Report>{
              'function': buildFunctionRecordStub(
                metrics: [
                  buildMetricValueStub<int>(
                    id: NumberOfParametersMetric.metricId,
                    value: 0,
                  ),
                ],
              ),
            }),
            issues: const [],
            antiPatternCases: const [],
          ),
        ];

        await _reporter.report(records);
        await _verboseReporter.report(records);

        verifyNever(() => output.writeln(any()));

        final verboseReport = verify(() => verboseOutput.writeln(captureAny()))
            .captured
            .cast<String>();
        expect(verboseReport, hasLength(3));
        expect(
          verboseReport[1],
          contains('number of arguments: \x1B[38;5;7m0\x1B[0m'),
        );
      });

      test('with a lot of arguments', () async {
        final records = [
          LintFileReport(
            path: fullPath,
            relativePath: 'example.dart',
            classes: Map.unmodifiable(<String, Report>{}),
            functions: Map.unmodifiable(<String, Report>{
              'function': buildFunctionRecordStub(
                metrics: [
                  buildMetricValueStub<int>(
                    id: NumberOfParametersMetric.metricId,
                    value: 10,
                    level: MetricValueLevel.alarm,
                  ),
                ],
              ),
            }),
            issues: const [],
            antiPatternCases: const [],
          ),
        ];

        await _reporter.report(records);

        final report =
            verify(() => output.writeln(captureAny())).captured.cast<String>();
        expect(report, hasLength(3));
        expect(
          report[1],
          contains('number of arguments: \x1B[38;5;1m10\x1B[0m'),
        );
      });

      test('with low nested level', () async {
        final records = [
          LintFileReport(
            path: fullPath,
            relativePath: 'example.dart',
            classes: Map.unmodifiable(<String, Report>{}),
            functions: Map.unmodifiable(<String, Report>{
              'function': buildFunctionRecordStub(
                metrics: const [
                  MetricValue<int>(
                    metricsId: MaximumNestingLevelMetric.metricId,
                    documentation: MetricDocumentation(
                      name: '',
                      shortName: '',
                      brief: '',
                      measuredType: EntityType.classEntity,
                      examples: [],
                    ),
                    value: 2,
                    level: MetricValueLevel.none,
                    comment: '',
                  ),
                ],
              ),
            }),
            issues: const [],
            antiPatternCases: const [],
          ),
        ];

        await _reporter.report(records);
        await _verboseReporter.report(records);

        verifyNever(() => output.writeln(any()));

        final verboseReport = verify(() => verboseOutput.writeln(captureAny()))
            .captured
            .cast<String>();
        expect(verboseReport, hasLength(3));
        expect(
          verboseReport[1],
          contains('nesting level: \x1B[38;5;7m2\x1B[0m'),
        );
      });

      test('with high nested level', () async {
        final records = [
          LintFileReport(
            path: fullPath,
            relativePath: 'example.dart',
            classes: Map.unmodifiable(<String, Report>{}),
            functions: Map.unmodifiable(<String, Report>{
              'function': buildFunctionRecordStub(
                metrics: const [
                  MetricValue<int>(
                    metricsId: MaximumNestingLevelMetric.metricId,
                    documentation: MetricDocumentation(
                      name: '',
                      shortName: '',
                      brief: '',
                      measuredType: EntityType.classEntity,
                      examples: [],
                    ),
                    value: 7,
                    level: MetricValueLevel.warning,
                    comment: '',
                  ),
                ],
              ),
            }),
            issues: const [],
            antiPatternCases: const [],
          ),
        ];

        await _reporter.report(records);

        final report =
            verify(() => output.writeln(captureAny())).captured.cast<String>();
        expect(report, hasLength(3));
        expect(report[1], contains('nesting level: \x1B[38;5;3m7\x1B[0m'));
      });
    });

    test('with design issues', () async {
      final records = [
        LintFileReport(
          path: fullPath,
          relativePath: 'example.dart',
          classes: Map.unmodifiable(<String, Report>{}),
          functions: Map.unmodifiable(<String, Report>{}),
          issues: const [],
          antiPatternCases: [
            Issue(
              ruleId: 'patternId1',
              documentation: Uri.parse('https://docu.edu/patternId1.html'),
              location: SourceSpanBase(
                SourceLocation(
                  1,
                  sourceUrl: Uri.parse(fullPath),
                  line: 2,
                  column: 3,
                ),
                SourceLocation(6, sourceUrl: Uri.parse(fullPath)),
                'issue',
              ),
              severity: Severity.none,
              message: 'first issue message',
              verboseMessage: 'recommendation',
            ),
          ],
        ),
      ];

      await _reporter.report(records);

      final report =
          verify(() => output.writeln(captureAny())).captured.cast<String>();
      expect(report, hasLength(3));
      expect(
        report[1],
        equals(
          '\x1B[38;5;3mDesign  \x1B[0mfirst issue message : 2:3 : patternId1 https://docu.edu/patternId1.html',
        ),
      );
    });

    test('with style severity issues', () async {
      final records = [
        LintFileReport(
          path: fullPath,
          relativePath: 'example.dart',
          classes: Map.unmodifiable(<String, Report>{}),
          functions: Map.unmodifiable(<String, Report>{}),
          issues: [
            Issue(
              ruleId: 'ruleId1',
              documentation: Uri.parse('https://docu.edu/ruleId1.html'),
              severity: Severity.style,
              location: SourceSpanBase(
                SourceLocation(
                  1,
                  sourceUrl: Uri.parse(fullPath),
                  line: 2,
                  column: 3,
                ),
                SourceLocation(6, sourceUrl: Uri.parse(fullPath)),
                'issue',
              ),
              message: 'first issue message',
              suggestion: const Replacement(
                comment: 'correction comment',
                replacement: 'correction',
              ),
            ),
          ],
          antiPatternCases: const [],
        ),
      ];

      await _reporter.report(records);

      final report =
          verify(() => output.writeln(captureAny())).captured.cast<String>();
      expect(report, hasLength(3));
      expect(
        report[1],
        equals(
          '\x1B[38;5;4mStyle   \x1B[0mfirst issue message : 2:3 : ruleId1 https://docu.edu/ruleId1.html',
        ),
      );
    });
  });
}
