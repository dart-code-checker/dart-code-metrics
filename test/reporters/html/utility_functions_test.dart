@TestOn('vm')

import 'package:dart_code_metrics/src/reporters/html/utility_functions.dart';
import 'package:test/test.dart';

void main() {
  group('Utility function: renderMetric returns dom elements for metric', () {
    const metricName = 'metricName';
    const metricValue = 'metricValue';

    test('with violation', () {
      expect(
          renderMetric(metricName, metricValue, withViolation: true).outerHtml,
          equals(
              '<div class="metrics-total metrics-total--violations"><span class="metrics-total__label">metricName : </span><span class="metrics-total__count">metricValue</span></div>'));
    });

    test('without violation', () {
      expect(
          renderMetric(metricName, metricValue).outerHtml,
          equals(
              '<div class="metrics-total"><span class="metrics-total__label">metricName : </span><span class="metrics-total__count">metricValue</span></div>'));
    });
  });
}
