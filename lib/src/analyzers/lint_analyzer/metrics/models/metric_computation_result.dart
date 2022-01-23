import '../../models/context_message.dart';

/// An internal model for representing a value computed by a metric.
class MetricComputationResult<T> {
  /// The actual value computed by the metric.
  final T value;

  /// The additional information associated with the value.
  final Iterable<ContextMessage> context;

  /// Initialize a newly created [MetricComputationResult].
  const MetricComputationResult({
    required this.value,
    this.context = const [],
  });
}
