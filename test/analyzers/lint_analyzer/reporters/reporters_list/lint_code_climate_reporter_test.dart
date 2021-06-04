@TestOn('vm')
import 'dart:convert';
import 'dart:io';

import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/metrics_list/maximum_nesting_level/maximum_nesting_level_metric.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/metrics_list/number_of_methods_metric.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/models/metric_documentation.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/models/metric_value.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/models/metric_value_level.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/entity_type.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/issue.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/lint_file_report.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/replacement.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/report.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/reporters/reporters_list/code_climate/lint_code_climate_reporter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:source_span/source_span.dart';
import 'package:test/test.dart';

import '../../../../stubs_builders.dart';

class IOSinkMock extends Mock implements IOSink {}

Map<String, Object?> _decodeReport(Iterable<String> lines) =>
    json.decode(lines.first.replaceAll('\x00', '')) as Map<String, Object?>;

void main() {
  group('LintCodeClimateReporter.report report about', () {
    // ignore: close_sinks
    late IOSinkMock output;
    const fullPath = '/home/developer/work/project/example.dart';

    late LintCodeClimateReporter _reporter;

    setUp(() {
      output = IOSinkMock();

      _reporter = LintCodeClimateReporter(
        output,
        metrics: {},
      );
    });

    test('empty file', () async {
      await _reporter.report([]);

      verifyNever(() => output.writeln(any()));
    });

    test('file with design issues', () async {
      const _issuePatternId = 'patternId1';
      const _issuePatternDocumentation = 'https://docu.edu/patternId1.html';
      const _issueLine = 2;
      const _issueMessage = 'first issue message';
      const _issueRecommendation = 'issue recommendation';

      final records = [
        LintFileReport(
          path: fullPath,
          relativePath: 'example.dart',
          classes: Map.unmodifiable(<String, Report>{}),
          functions: Map.unmodifiable(<String, Report>{}),
          issues: const [],
          antiPatternCases: [
            Issue(
              ruleId: _issuePatternId,
              documentation: Uri.parse(_issuePatternDocumentation),
              location: SourceSpanBase(
                SourceLocation(
                  1,
                  sourceUrl: Uri.parse(fullPath),
                  line: _issueLine,
                  column: 3,
                ),
                SourceLocation(6, sourceUrl: Uri.parse(fullPath)),
                'issue',
              ),
              severity: Severity.style,
              message: 'first issue message',
              verboseMessage: _issueRecommendation,
            ),
          ],
        ),
      ];

      await _reporter.report(records);
      final report = _decodeReport(
        verify(() => output.writeln(captureAny())).captured.cast<String>(),
      );

      expect(report, containsPair('type', 'issue'));
      expect(report, containsPair('check_name', _issuePatternId));
      expect(report, containsPair('description', _issueMessage));
      expect(report, containsPair('categories', ['Complexity']));
      expect(
        report,
        containsPair('location', {
          'path': 'example.dart',
          'lines': {'begin': _issueLine, 'end': _issueLine},
        }),
      );
      expect(report, containsPair('remediation_points', 50000));
      expect(report, containsPair('severity', 'info'));
      expect(
        report,
        containsPair('fingerprint', '8842a666b8aee4f2eae51205e0114dae'),
      );
    });

    test('file with style severity issues', () async {
      const _issueRuleId = 'ruleId1';
      const _issueRuleDocumentation = 'https://docu.edu/ruleId1.html';

      const _issueLine = 2;
      const _issueMessage = 'first issue message';

      final records = [
        LintFileReport(
          path: fullPath,
          relativePath: 'example.dart',
          classes: Map.unmodifiable(<String, Report>{}),
          functions: Map.unmodifiable(<String, Report>{}),
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
                  column: 3,
                ),
                SourceLocation(6, sourceUrl: Uri.parse(fullPath)),
                'issue',
              ),
              message: _issueMessage,
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
      final report = _decodeReport(
        verify(() => output.writeln(captureAny())).captured.cast<String>(),
      );

      expect(report, containsPair('type', 'issue'));
      expect(report, containsPair('check_name', _issueRuleId));
      expect(report, containsPair('description', _issueMessage));
      expect(report, containsPair('categories', ['Style']));
      expect(
        report,
        containsPair('location', {
          'path': 'example.dart',
          'lines': {'begin': _issueLine, 'end': _issueLine},
        }),
      );
      expect(report, containsPair('remediation_points', 50000));
      expect(report, containsPair('severity', 'minor'));

      expect(
        report,
        containsPair('fingerprint', 'ed45b12bc8354f240bfe37e1c1eb0f58'),
      );
    });

    group('components', () {
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
        verifyNever(() => output.writeln(any()));
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
        final report = _decodeReport(
          verify(() => output.writeln(captureAny())).captured.cast<String>(),
        );

        expect(report, containsPair('type', 'issue'));
        expect(report, containsPair('check_name', 'numberOfMethods'));
        expect(
          report,
          containsPair(
            'description',
            'Component `class` has 20 number of methods (exceeds 10 allowed). Consider refactoring.',
          ),
        );
        expect(report, containsPair('categories', ['Complexity']));
        expect(
          report,
          containsPair(
            'location',
            {
              'path': 'example.dart',
              'lines': {'begin': 0, 'end': 0},
            },
          ),
        );
        expect(report, containsPair('remediation_points', 50000));
        expect(report, containsPair('severity', 'info'));

        expect(
          report,
          containsPair('fingerprint', 'de1258f0c898f266343b3e435e23310c'),
        );
      });
    });

    group('function', () {
      test('with low nesting level', () async {
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
                    value: 3,
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
        verifyNever(() => output.writeln(any()));
      });

      test('with high nesting level', () async {
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
        final report = _decodeReport(
          verify(() => output.writeln(captureAny())).captured.cast<String>(),
        );

        expect(report, containsPair('type', 'issue'));
        expect(report, containsPair('check_name', 'nestingLevel'));
        expect(
          report,
          containsPair(
            'description',
            'Function `function` has a Nesting Level of 7 (exceeds 5 allowed). Consider refactoring.',
          ),
        );
        expect(report, containsPair('categories', ['Complexity']));
        expect(
          report,
          containsPair(
            'location',
            {
              'path': 'example.dart',
              'lines': {'begin': 0, 'end': 0},
            },
          ),
        );
        expect(report, containsPair('remediation_points', 50000));
        expect(report, containsPair('severity', 'info'));

        expect(
          report,
          containsPair('fingerprint', 'ae340b5c0614d47b75150fdfac58a5e1'),
        );
      });
    });
  });

  group('LintCodeClimateReporter.report gitlab compatible report about', () {
    // ignore: close_sinks
    late IOSinkMock output;
    const fullPath = '/home/developer/work/project/example.dart';

    late LintCodeClimateReporter _reporter;

    setUp(() {
      output = IOSinkMock();

      _reporter = LintCodeClimateReporter(
        output,
        metrics: {},
        gitlabCompatible: true,
      );
    });

    test('empty file', () async {
      await _reporter.report([]);

      verifyNever(() => output.writeln(any()));
    });

    test('file with design issues', () async {
      const _issuePatternId = 'patternId1';
      const _issuePatternDocumentation = 'https://docu.edu/patternId1.html';
      const _issueLine = 2;
      const _issueMessage = 'first issue message';
      const _issueRecommendation = 'issue recommendation';

      final records = [
        LintFileReport(
          path: fullPath,
          relativePath: 'example.dart',
          classes: Map.unmodifiable(<String, Report>{}),
          functions: Map.unmodifiable(<String, Report>{}),
          issues: const [],
          antiPatternCases: [
            Issue(
              ruleId: _issuePatternId,
              documentation: Uri.parse(_issuePatternDocumentation),
              location: SourceSpanBase(
                SourceLocation(
                  1,
                  sourceUrl: Uri.parse(fullPath),
                  line: _issueLine,
                  column: 3,
                ),
                SourceLocation(6, sourceUrl: Uri.parse(fullPath)),
                'issue',
              ),
              severity: Severity.none,
              message: 'first issue message',
              verboseMessage: _issueRecommendation,
            ),
          ],
        ),
      ];

      await _reporter.report(records);
      final report = (json.decode(
        verify(() => output.writeln(captureAny()))
            .captured
            .cast<String>()
            .first,
      ) as List<Object?>)
          .first as Map<String, Object?>;

      expect(report, containsPair('type', 'issue'));
      expect(report, containsPair('check_name', _issuePatternId));
      expect(report, containsPair('description', _issueMessage));
      expect(report, containsPair('categories', ['Complexity']));
      expect(
        report,
        containsPair('location', {
          'path': 'example.dart',
          'lines': {'begin': _issueLine, 'end': _issueLine},
        }),
      );
      expect(report, containsPair('remediation_points', 50000));
      expect(report, containsPair('severity', 'info'));
      expect(
        report,
        containsPair('fingerprint', '8842a666b8aee4f2eae51205e0114dae'),
      );
    });
  });
}
