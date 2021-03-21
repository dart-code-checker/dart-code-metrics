import 'package:meta/meta.dart';
import 'package:source_span/source_span.dart';

import 'metric_value.dart';
import 'metric_value_level.dart';

/// Represents the metrics report collected for a entity
@immutable
class Report {
  /// Source code location of the target entity
  final SourceSpan location;

  /// Target entity metrics
  final Iterable<MetricValue<num>> metrics;

  /// Returns a certain target metric
  MetricValue<num> metric(String id) => metrics
      .firstWhere((metric) => metric.metricsId == id, orElse: () => null);

  // TODO(dkrutskikh): after migrate on NullSafety migrate on iterable extensions from collection package
  /// Most of highest reported level of a metric
  MetricValueLevel get metricsLevel => metrics.isNotEmpty
      ? metrics.reduce((a, b) => a.level > b.level ? a : b).level
      : MetricValueLevel.none;

  /// Initialize a newly created [Report].
  const Report({@required this.location, @required this.metrics});
}
