import 'package:dart_code_metrics/src/models/entity_type.dart';
import 'package:dart_code_metrics/src/models/metric_documentation.dart';
import 'package:dart_code_metrics/src/models/metric_value.dart';
import 'package:dart_code_metrics/src/models/metric_value_level.dart';

MetricValue<T> buildMetricValueStub<T>({
  required String id,
  required T value,
  EntityType type = EntityType.methodEntity,
  MetricValueLevel level = MetricValueLevel.none,
}) =>
    MetricValue<T>(
      metricsId: id,
      documentation: MetricDocumentation(
        name: id,
        shortName: id.toUpperCase(),
        brief: 'brief $id',
        measuredType: type,
        examples: const [],
      ),
      value: value,
      level: level,
      comment: '',
    );
