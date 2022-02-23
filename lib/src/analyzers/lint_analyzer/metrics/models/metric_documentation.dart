import '../../models/entity_type.dart';

/// Represents any metric documentation.
class MetricDocumentation {
  /// The name of the metric.
  final String name;

  /// The short name of the metric.
  final String shortName;

  /// The type of entities which will be measured by the metric.
  final EntityType measuredType;

  /// The recommended threshold value for this metric.
  final num recommendedThreshold;

  /// Initialize a newly created [MetricDocumentation].
  ///
  /// This data object is used for a documentation generating from a source code.
  const MetricDocumentation({
    required this.name,
    required this.shortName,
    required this.measuredType,
    required this.recommendedThreshold,
  });
}
