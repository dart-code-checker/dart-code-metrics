import 'package:meta/meta.dart';

import '../../models/entity_type.dart';

/// Represents any metric documentation.
@immutable
class MetricDocumentation {
  /// The name of the metric.
  final String name;

  /// The short name of the metric.
  final String shortName;

  /// The short message with formal statement about the metric.
  final String brief;

  /// The type of entities which will be measured by the metric.
  final EntityType measuredType;

  /// The recomended threshold value for this metric
  final num recomendedThreshold;

  /// Initialize a newly created [MetricDocumentation].
  ///
  /// This data object is used for a documentation generating from a source code.
  const MetricDocumentation({
    required this.name,
    required this.shortName,
    required this.brief,
    required this.measuredType,
    required this.recomendedThreshold,
  });
}
