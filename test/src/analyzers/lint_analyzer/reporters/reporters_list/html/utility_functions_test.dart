import 'package:dart_code_metrics/src/analyzers/lint_analyzer/reporters/reporters_list/html/models/file_metrics_report.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/reporters/reporters_list/html/models/report_table_record.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/reporters/reporters_list/html/utility_functions.dart';
import 'package:test/test.dart';

void main() {
  group('Utility function:', () {
    const metricName = 'metricName';

    group('renderSummaryMetric returns dom elements for metric', () {
      const metricValue = 128;

      test('with violation', () {
        expect(
          renderSummaryMetric(metricName, metricValue, violations: 10)
              .outerHtml,
          equals(
            '<div class="metrics-total metrics-total--violations"><span class="metrics-total__label">metricName / violations : </span><span class="metrics-total__count">128 / 10</span></div>',
          ),
        );

        expect(
          renderSummaryMetric(metricName, metricValue, forceViolations: true)
              .outerHtml,
          equals(
            '<div class="metrics-total metrics-total--violations"><span class="metrics-total__label">metricName : </span><span class="metrics-total__count">128</span></div>',
          ),
        );
      });

      test('without violation', () {
        expect(
          renderSummaryMetric(metricName, metricValue).outerHtml,
          equals(
            '<div class="metrics-total"><span class="metrics-total__label">metricName : </span><span class="metrics-total__count">128</span></div>',
          ),
        );
      });
    });

    test('renderTableRecord returns dom elements for report table record', () {
      expect(
        renderTableRecord(
          const ReportTableRecord(
            title: 'fileName',
            link: 'fileLink',
            report: FileMetricsReport(
              averageArgumentsCount: 1,
              argumentsCountViolations: 0,
              averageMaintainabilityIndex: 2,
              maintainabilityIndexViolations: 2,
              totalCyclomaticComplexity: 4,
              cyclomaticComplexityViolations: 4,
              totalSourceLinesOfCode: 5,
              sourceLinesOfCodeViolations: 0,
              averageMaximumNestingLevel: 6,
              maximumNestingLevelViolations: 6,
              technicalDebt: 0,
              technicalDebtViolations: 0,
              technicalDebtUnitType: null,
            ),
          ),
        ).outerHtml,
        equals(
          '<tr><td><a href="fileLink">fileName</a></td><td class="with-violations">4 / 4</td><td class="">5</td><td class="with-violations">2 / 2</td><td class="">1</td><td class="with-violations">6 / 6</td><td class="">0.0</td></tr>',
        ),
      );
    });
  });
}
