import 'package:meta/meta.dart';
import 'package:source_span/source_span.dart';

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

  /// The code snippet that is used for the metric documentation generating.
  final Iterable<SourceSpan> examples;

  /// Initialize a newly created [MetricDocumentation].
  ///
  /// This data object is used for a documentation generating from a source code.
  const MetricDocumentation({
    required this.name,
    required this.shortName,
    required this.brief,
    required this.measuredType,
    required this.examples,
  });
}
