import '../../models/context_message.dart';
import 'metric_documentation.dart';
import 'metric_value_level.dart';

/// Represents a value computed by the metric.
class MetricValue<T extends num> {
  /// The id of the computed metric.
  final String metricsId;

  /// The documentation associated with the computed metric.
  final MetricDocumentation documentation;

  /// The actual value computed by the metric.
  final T value;

  /// The human readable unit type.
  final String? unitType;

  /// The level of this value computed by the metric.
  final MetricValueLevel level;

  /// The message for the user containing information about this value.
  final String comment;

  /// The message for the user containing information about how the user can
  /// improve this value or `null` if there is no recommendation.
  final String? recommendation;

  /// An additional information associated with this value.
  ///
  /// The context to help the user understand how the metric was computed.
  final Iterable<ContextMessage> context;

  /// Initialize a newly created [MetricValue].
  ///
  /// The value will have the given [metricsId], [documentation] and [level].
  /// They will be used to classify the value in IDE or in reporters.
  /// The [value], [comment], [recommendation] and [context] (if provided),
  /// will be used to complete and improve the information for the end user.
  const MetricValue({
    required this.metricsId,
    required this.documentation,
    required this.value,
    this.unitType,
    required this.level,
    required this.comment,
    this.recommendation,
    this.context = const [],
  });
}
