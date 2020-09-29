@TestOn('vm')
import 'package:dart_code_metrics/src/models/report_metric.dart';
import 'package:dart_code_metrics/src/models/violation_level.dart';
import 'package:dart_code_metrics/src/reporters/html/utility_functions.dart';
import 'package:test/test.dart';

void main() {
  group('Utility function:', () {
    const metricName = 'metricName';

    group('renderSummaryMetric returns dom elements for metric', () {
      const metricValue = 'metricValue';

      test('with violation', () {
        expect(
            renderSummaryMetric(metricName, metricValue, withViolation: true)
                .outerHtml,
            equals(
                '<div class="metrics-total metrics-total--violations"><span class="metrics-total__label">metricName : </span><span class="metrics-total__count">metricValue</span></div>'));
      });

      test('without violation', () {
        expect(
            renderSummaryMetric(metricName, metricValue).outerHtml,
            equals(
                '<div class="metrics-total"><span class="metrics-total__label">metricName : </span><span class="metrics-total__count">metricValue</span></div>'));
      });
    });

    test(
        'renderFunctionMetric returns dom elements for function metric in tooltip',
        () {
      expect(
          renderFunctionMetric(
                  metricName,
                  const ReportMetric(
                      value: 10, violationLevel: ViolationLevel.warning))
              .outerHtml,
          equals(
              '<div class="metrics-source-code__tooltip-section"><p class="metrics-source-code__tooltip-text"><span class="metrics-source-code__tooltip-label">metricname:&amp;nbsp;</span><span>10</span></p><p class="metrics-source-code__tooltip-text"><span class="metrics-source-code__tooltip-label">metricname violation level:&amp;nbsp;</span><span class="metrics-source-code__tooltip-level metrics-source-code__tooltip-level--warning">warning</span></p></div>'));
    });
  });
}
