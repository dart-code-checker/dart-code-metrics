@TestOn('vm')
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/models/metric_documentation.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/models/metric_value.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/models/metric_value_level.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/entity_type.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/reporters/models/file_metrics_report.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/reporters/reporters_list/html/lint_html_reporter.dart';
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

    test(
      'renderFunctionMetric returns dom elements for function metric in tooltip',
      () {
        expect(
          renderFunctionMetric(
            metricName,
            const MetricValue(
              metricsId: '',
              documentation: MetricDocumentation(
                name: '',
                shortName: '',
                brief: '',
                measuredType: EntityType.classEntity,
                examples: [],
              ),
              value: 10,
              level: MetricValueLevel.warning,
              comment: '',
            ),
          ).outerHtml,
          equals(
            '<div class="metrics-source-code__tooltip-section"><p class="metrics-source-code__tooltip-text"><span class="metrics-source-code__tooltip-label">metricname:&amp;nbsp;</span><span>10</span></p><p class="metrics-source-code__tooltip-text"><span class="metrics-source-code__tooltip-label">metricname violation level:&amp;nbsp;</span><span class="metrics-source-code__tooltip-level metrics-source-code__tooltip-level--warning">warning</span></p></div>',
          ),
        );
      },
    );

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
              averageMethodsCount: 3,
              methodsCountViolations: 0,
              totalCyclomaticComplexity: 4,
              cyclomaticComplexityViolations: 4,
              totalSourceLinesOfCode: 5,
              sourceLinesOfCodeViolations: 0,
              averageMaximumNestingLevel: 6,
              maximumNestingLevelViolations: 6,
            ),
          ),
        ).outerHtml,
        equals(
          '<tr><td><a href="fileLink">fileName</a></td><td class="with-violations">4 / 4</td><td class="">5</td><td class="with-violations">2 / 2</td><td class="">1</td><td class="with-violations">6 / 6</td></tr>',
        ),
      );
    });
  });
}
