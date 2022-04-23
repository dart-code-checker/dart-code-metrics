import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/metrics_list/cyclomatic_complexity/cyclomatic_complexity_metric.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/metrics_list/source_lines_of_code/source_lines_of_code_metric.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/models/metric_value_level.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/issue.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/lint_file_report.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/report.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/utils/report_utils.dart';
import 'package:source_span/source_span.dart';
import 'package:test/test.dart';

import '../../../../stubs_builders.dart';

void main() {
  group('Report util', () {
    const fullPathStub = '~/lib/src/foo.dart';
    const relativePathStub = 'lib/src/foo.dart';
    const fullPathStub2 = '~/test/src/foo.dart';
    const relativePathStub2 = 'test/src/foo.dart';
    const fullPathStub3 = '~/lib/src/bar.dart';
    const relativePathStub3 = 'lib/src/bar.dart';

    final emptyRecord = [
      LintFileReport(
        path: fullPathStub,
        relativePath: relativePathStub,
        file: buildReportStub(),
        classes: const {},
        functions: {'a': buildFunctionRecordStub(metrics: [])},
        issues: const [],
        antiPatternCases: const [],
      ),
    ];

    final fileRecords = [
      LintFileReport(
        path: fullPathStub,
        relativePath: relativePathStub,
        file: buildReportStub(),
        classes: Map.unmodifiable(<String, Report>{}),
        functions: Map.unmodifiable(<String, Report>{
          'a': buildFunctionRecordStub(
            metrics: [
              buildMetricValueStub<int>(
                id: CyclomaticComplexityMetric.metricId,
                value: 5,
              ),
              buildMetricValueStub<int>(
                id: SourceLinesOfCodeMetric.metricId,
                value: 10,
              ),
            ],
          ),
        }),
        issues: [
          Issue(
            ruleId: 'rule',
            documentation: Uri.parse('http://documentation.org'),
            location: SourceSpan(SourceLocation(0), SourceLocation(0), ''),
            severity: Severity.error,
            message: 'issue message',
          ),
        ],
        antiPatternCases: const [],
      ),
      LintFileReport(
        path: fullPathStub2,
        relativePath: relativePathStub2,
        file: buildReportStub(),
        classes: Map.unmodifiable(<String, Report>{}),
        functions: Map.unmodifiable(<String, Report>{
          'a': buildFunctionRecordStub(
            metrics: [
              buildMetricValueStub<int>(
                id: CyclomaticComplexityMetric.metricId,
                value: 45,
                level: MetricValueLevel.warning,
              ),
              buildMetricValueStub<int>(
                id: SourceLinesOfCodeMetric.metricId,
                value: 20,
                level: MetricValueLevel.warning,
              ),
            ],
          ),
        }),
        issues: const [],
        antiPatternCases: const [],
      ),
      LintFileReport(
        path: fullPathStub3,
        relativePath: relativePathStub3,
        file: buildReportStub(),
        classes: Map.unmodifiable(<String, Report>{}),
        functions: Map.unmodifiable(<String, Report>{
          'a': buildFunctionRecordStub(
            metrics: [
              buildMetricValueStub<int>(
                id: CyclomaticComplexityMetric.metricId,
                value: 15,
              ),
              buildMetricValueStub<int>(
                id: SourceLinesOfCodeMetric.metricId,
                value: 30,
                level: MetricValueLevel.warning,
              ),
            ],
          ),
        }),
        issues: const [],
        antiPatternCases: [
          Issue(
            ruleId: 'pattern',
            documentation: Uri.parse('http://documentation.org'),
            location: SourceSpan(SourceLocation(1), SourceLocation(1), ''),
            severity: Severity.style,
            message: 'issue message',
          ),
        ],
      ),
    ];

    test('maxMetricViolationLevel returns violation level', () {
      expect(maxMetricViolationLevel(fileRecords), MetricValueLevel.warning);
      expect(maxMetricViolationLevel([]), MetricValueLevel.none);
    });

    test(
      'hasIssueWithSeverity returns true if found issue with required severity',
      () {
        expect(hasIssueWithSeverity(fileRecords, Severity.error), isTrue);
        expect(hasIssueWithSeverity(fileRecords, Severity.warning), isFalse);
        expect(
          hasIssueWithSeverity(fileRecords, Severity.performance),
          isFalse,
        );
        expect(hasIssueWithSeverity(fileRecords, Severity.style), isTrue);
        expect(hasIssueWithSeverity(fileRecords, Severity.none), isFalse);
      },
    );

    test(
      'scannedFolders returns array with top level folders with source code',
      () {
        expect(scannedFolders(fileRecords), equals(['lib', 'test']));
      },
    );

    test('totalFiles returns count of reported files', () {
      expect(totalFiles(fileRecords), equals(3));
    });

    test('totalSLOC returns total numbers of scanned source lines of code', () {
      expect(totalSLOC(fileRecords), equals(60));
    });

    test('totalClasses returns total numbers of scanned classes', () {
      expect(totalClasses(fileRecords), isZero);
    });

    test(
      'averageCYCLO returns average numbers of cyclomatic complexity per source lines of code',
      () {
        expect(averageCYCLO(emptyRecord), closeTo(0.0, 0.01));
        expect(averageCYCLO(fileRecords), closeTo(1.08, 0.01));
      },
    );
    test(
      'averageSLOC returns average numbers of scanned source lines of code per function/method',
      () {
        expect(averageSLOC(fileRecords), equals(20));
      },
    );

    test('metricViolations returns total count of metric violations', () {
      expect(
        metricViolations(fileRecords, CyclomaticComplexityMetric.metricId),
        equals(1),
      );
      expect(
        metricViolations(fileRecords, SourceLinesOfCodeMetric.metricId),
        equals(2),
      );
    });
  });
}
