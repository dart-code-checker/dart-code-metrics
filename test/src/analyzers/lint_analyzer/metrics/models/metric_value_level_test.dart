import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/models/metric_value_level.dart';
import 'package:test/test.dart';

void main() {
  group('MetricValueLevel', () {
    test('fromString converts string to MetricValueLevel object', () {
      const humanReadableLevels = ['NoTEd', 'wARniNG', 'aLaRM', '', null];

      assert(
        humanReadableLevels.length == MetricValueLevel.values.length + 1,
        "humanReadableLevels has invalid lengths, perhaps array doesn't contain all values",
      );

      expect(
        humanReadableLevels.map(MetricValueLevel.fromString),
        equals([
          MetricValueLevel.noted,
          MetricValueLevel.warning,
          MetricValueLevel.alarm,
          MetricValueLevel.none,
          null,
        ]),
      );
    });
    test('operators', () {
      expect(MetricValueLevel.none < MetricValueLevel.noted, isTrue);
      expect(MetricValueLevel.noted < MetricValueLevel.noted, isFalse);
      expect(MetricValueLevel.warning < MetricValueLevel.noted, isFalse);

      expect(MetricValueLevel.none <= MetricValueLevel.noted, isTrue);
      expect(MetricValueLevel.noted <= MetricValueLevel.noted, isTrue);
      expect(MetricValueLevel.warning <= MetricValueLevel.noted, isFalse);

      expect(MetricValueLevel.none > MetricValueLevel.noted, isFalse);
      expect(MetricValueLevel.noted > MetricValueLevel.noted, isFalse);
      expect(MetricValueLevel.warning > MetricValueLevel.noted, isTrue);

      expect(MetricValueLevel.none >= MetricValueLevel.noted, isFalse);
      expect(MetricValueLevel.noted >= MetricValueLevel.noted, isTrue);
      expect(MetricValueLevel.warning >= MetricValueLevel.noted, isTrue);
    });
  });
}
