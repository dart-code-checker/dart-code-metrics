import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import 'package:source_span/source_span.dart';

import '../lint_analyzer/metrics/models/metric_value.dart';
import '../lint_analyzer/metrics/models/metric_value_level.dart';

/// Represents a metrics report collected for an entity.
@immutable
class Report {
  /// The source code location of the target entity.
  final SourceSpan location;

  /// Target entity metrics.
  final Iterable<MetricValue<num>> metrics;

  /// Returns a certain target metric.
  MetricValue<num>? metric(String id) =>
      metrics.firstWhereOrNull((metric) => metric.metricsId == id);

  /// The highest reported level of a metric.
  MetricValueLevel get metricsLevel => metrics.isNotEmpty
      ? metrics.map((value) => value.level).max
      : MetricValueLevel.none;

  /// Initialize a newly created [Report].
  const Report({required this.location, required this.metrics});
}
