import 'package:meta/meta.dart';

import 'context_message.dart';
import 'metric_documentation.dart';
import 'metric_value_level.dart';

/// Represents a value computed by the metric
@immutable
class MetricValue<T> {
  /// The id of the metric whose compute this value
  final String metricsId;

  /// Documentation associated with the metrics whose compute this value
  final MetricDocumentation documentation;

  /// The actual value computed by the metric
  final T value;

  /// Level of this value computed by the metric
  final MetricValueLevel level;

  /// Message for user containing information about this value
  final String comment;

  /// Message for user containing information about how the user can improve this value
  final String recommendation;

  /// Additional information associated with this value
  ///
  /// That provide context to help the user understand how the metric compute this one
  final Iterable<ContextMessage> context;

  /// Initialize a newly created [MetricValue].
  ///
  /// The value will have the given [metricsId], [documentation] and [level]
  /// they will be used to classificate value in IDE or in reporters.
  /// [value] and [comment] or if [recommendation] and [context] are provided,
  /// used to complete and improve the information for the end user.
  const MetricValue({
    @required this.metricsId,
    @required this.documentation,
    @required this.value,
    @required this.level,
    @required this.comment,
    this.recommendation,
    this.context = const [],
  });
}
