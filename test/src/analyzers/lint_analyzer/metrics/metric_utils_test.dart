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
          'https://dcm.dev/docs/metrics/metric-id-1',
        ),
      );
      expect(
        documentation(metricId2).pathSegments.last,
        equals(metricId2),
      );
    });

    test('readThreshold returns a threshold value from Map based config', () {
      const metricId3 = 'metric-id-3';
      const metricId4 = 'metric-id-4';
      const metricId5 = 'metric-id-5';

      const metricId1Value = 10;
      const metricId2Value = 0.5;

      const config = {
        metricId1: '$metricId1Value',
        metricId2: {'threshold': '$metricId2Value'},
        metricId3: '',
        metricId4: null,
      };

      expect(
        readNullableThreshold<int>(config, metricId1),
        equals(metricId1Value),
      );

      expect(
        readNullableThreshold<double>(config, metricId2),
        equals(metricId2Value),
      );

      expect(readNullableThreshold<int>(config, metricId3), isNull);

      expect(readNullableThreshold<double>(config, metricId4), isNull);

      expect(readNullableThreshold<int>(config, metricId5), isNull);
    });

    test('readConfigValue returns a value from Map based config', () {
      const metricId3 = 'metric-id-3';
      const metricId4 = 'metric-id-4';
      const metricId5 = 'metric-id-5';
      const metricId6 = 'metric-id-6';

      const metricId1Value = 10;
      const metricId2Value = 0.5;

      const config = {
        metricId1: '$metricId1Value',
        metricId2: {'value': '$metricId1Value'},
        metricId3: {'value': '$metricId2Value'},
        metricId4: {'value': 'message'},
        metricId5: null,
      };

      expect(readConfigValue<int>(config, metricId1, 'value'), isNull);

      expect(readConfigValue<int>(config, metricId2, 'value'), equals(10));

      expect(readConfigValue<double>(config, metricId3, 'value'), equals(0.5));

      expect(
        readConfigValue<String>(config, metricId4, 'value'),
        equals('message'),
      );

      expect(readConfigValue<int>(config, metricId5, 'value'), isNull);

      expect(readConfigValue<int>(config, metricId6, 'value'), isNull);
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
