import 'package:analyzer/dart/ast/ast.dart';
import 'package:collection/collection.dart';
import 'package:source_span/source_span.dart';

import '../metrics/models/metric_value.dart';
import '../metrics/models/metric_value_level.dart';

/// Represents a metrics report collected for an entity.
class Report {
  /// The source code location of the target entity.
  final SourceSpan location;

  /// The node that represents a dart code snippet in the AST structure.
  final AstNode declaration;

  /// Target entity metrics.
  final Iterable<MetricValue> metrics;

  /// Returns a certain target metric.
  MetricValue? metric(String id) =>
      metrics.firstWhereOrNull((metric) => metric.metricsId == id);

  /// The highest reported level of a metric.
  MetricValueLevel get metricsLevel => metrics.isNotEmpty
      ? metrics.map((value) => value.level).max
      : MetricValueLevel.none;

  /// Initialize a newly created [Report].
  const Report({
    required this.location,
    required this.metrics,
    required this.declaration,
  });
}
