@TestOn('vm')
import 'dart:convert';

import 'package:code_checker/checker.dart';
import 'package:code_checker/metrics.dart';
import 'package:code_checker/rules.dart';
import 'package:dart_code_metrics/src/obsoleted/config/config.dart' as metric;
import 'package:dart_code_metrics/src/obsoleted/models/file_record.dart';
import 'package:dart_code_metrics/src/obsoleted/models/function_record.dart';
import 'package:dart_code_metrics/src/obsoleted/reporters/code_climate/code_climate_reporter.dart';
import 'package:source_span/source_span.dart';
import 'package:test/test.dart';

import '../stubs_builders.dart';

Map<String, Object> _decodeReport(Iterable<String> lines) =>
    json.decode(lines.first.replaceAll('\x00', '')) as Map<String, Object>;

void main() {
  group('CodeClimateReporter.report report about', () {
    const fullPath = '/home/developer/work/project/example.dart';

    CodeClimateReporter _reporter;

    setUp(() {
      _reporter = CodeClimateReporter(reportConfig: const metric.Config());
    });

    test('empty file', () async {
      expect(await _reporter.report([]), isEmpty);
    });

    test('file with design issues', () async {
      const _issuePatternId = 'patternId1';
      const _issuePatternDocumentation = 'https://docu.edu/patternId1.html';
      const _issueLine = 2;
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

      final report = _decodeReport(await _reporter.report(records));

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
          designIssues: const [],
        ),
      ];

      final report = _decodeReport(await _reporter.report(records));

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

        expect(await _reporter.report(records), isEmpty);
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

        final report = _decodeReport(await _reporter.report(records));

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
          FileRecord(
            fullPath: fullPath,
            relativePath: 'example.dart',
            components: Map.unmodifiable(<String, Report>{}),
            functions: Map.unmodifiable(<String, FunctionRecord>{
              'function': buildFunctionRecordStub(
                metrics: const [
                  MetricValue<int>(
                    metricsId: MaximumNestingLevelMetric.metricId,
                    value: 3,
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

        expect(await _reporter.report(records), isEmpty);
      });

      test('with high nesting level', () async {
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

        final report = _decodeReport(await _reporter.report(records));

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

  group('CodeClimateReporter.report gitlab compatible report about', () {
    const fullPath = '/home/developer/work/project/example.dart';

    CodeClimateReporter _reporter;

    setUp(() {
      _reporter = CodeClimateReporter(
        reportConfig: const metric.Config(),
        gitlabCompatible: true,
      );
    });

    test('empty file', () async {
      expect(await _reporter.report([]), isEmpty);
    });

    test('file with design issues', () async {
      const _issuePatternId = 'patternId1';
      const _issuePatternDocumentation = 'https://docu.edu/patternId1.html';
      const _issueLine = 2;
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

      final report =
          (json.decode((await _reporter.report(records)).first) as List<Object>)
              .first as Map<String, Object>;

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
