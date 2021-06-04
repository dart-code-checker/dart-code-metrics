@TestOn('vm')
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/metric_utils.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/models/metric_value_level.dart';
import 'package:test/test.dart';

class ExampleImpl {}

void main() {
  group('Metric utils', () {
    const metricId1 = 'metric-id-1';
    const metricId2 = 'metric-id-2';

    test('documentation returns the url with documentation', () {
      expect(
        documentation(metricId1).toString(),
        equals(
          'https://github.com/dart-code-checker/dart-code-metrics/blob/master/doc/metrics/metric-id-1.md',
        ),
      );
      expect(
        documentation(metricId2).pathSegments.last,
        equals('$metricId2.md'),
      );
    });

    test('readThreshold returns a threshold value from Map based config', () {
      const metricId3 = 'metric-id-3';
      const metricId4 = 'metric-id-4';
      const metricId5 = 'metric-id-5';

      const metricId1Value = 10;
      const metricId2Value = 0.5;

      const _config = {
        metricId1: '$metricId1Value',
        metricId2: '$metricId2Value',
        metricId3: '',
        metricId4: null,
      };

      expect(
        readThreshold<int>(_config, metricId1, 15),
        equals(metricId1Value),
      );
      expect(
        readThreshold<double>(_config, metricId2, 15),
        equals(metricId2Value),
      );
      expect(readThreshold<int>(_config, metricId3, 15), equals(15));
      expect(readThreshold<double>(_config, metricId4, 15), equals(15));
      expect(readThreshold<int>(_config, metricId5, 15), equals(15));
    });

    test('valueLevel returns a level of passed value', () {
      expect(valueLevel(null, 10), equals(MetricValueLevel.none));
      expect(valueLevel(30, null), equals(MetricValueLevel.none));
      expect(valueLevel(null, null), equals(MetricValueLevel.none));

      expect(valueLevel(30, 10), equals(MetricValueLevel.alarm));
      expect(valueLevel(20, 10), equals(MetricValueLevel.warning));
      expect(valueLevel(10, 10), equals(MetricValueLevel.noted));
      expect(valueLevel(8, 10), equals(MetricValueLevel.none));

      expect(valueLevel(3.0, 1), equals(MetricValueLevel.alarm));
      expect(valueLevel(2.0, 1), equals(MetricValueLevel.warning));
      expect(valueLevel(1.0, 1), equals(MetricValueLevel.noted));
      expect(valueLevel(0.8, 1), equals(MetricValueLevel.none));
    });

    test('invertValueLevel returns a level of passed value', () {
      expect(invertValueLevel(null, 10), equals(MetricValueLevel.none));
      expect(invertValueLevel(30, null), equals(MetricValueLevel.none));
      expect(invertValueLevel(null, null), equals(MetricValueLevel.none));

      expect(invertValueLevel(1, 10), equals(MetricValueLevel.alarm));
      expect(invertValueLevel(5, 10), equals(MetricValueLevel.warning));
      expect(invertValueLevel(10, 10), equals(MetricValueLevel.noted));
      expect(invertValueLevel(13, 10), equals(MetricValueLevel.none));

      expect(invertValueLevel(0.1, 1), equals(MetricValueLevel.alarm));
      expect(invertValueLevel(0.5, 1), equals(MetricValueLevel.warning));
      expect(invertValueLevel(1.0, 1), equals(MetricValueLevel.noted));
      expect(invertValueLevel(1.25, 1), equals(MetricValueLevel.none));
    });

    test('isReportLevel returns true only on "warning" and "alarm"', () {
      <MetricValueLevel, Matcher>{
        MetricValueLevel.none: isFalse,
        MetricValueLevel.noted: isFalse,
        MetricValueLevel.warning: isTrue,
        MetricValueLevel.alarm: isTrue,
      }.forEach((key, value) {
        expect(isReportLevel(key), value);
      });
    });

    test(
      'userFriendlyType user friendly string representations of provided type',
      () {
        <Type, Matcher>{
          ''.runtimeType: equals('String'),
          ExampleImpl().runtimeType: equals('Example'),
        }.forEach((key, value) {
          expect(userFriendlyType(key), value);
        });
      },
    );
  });
}
