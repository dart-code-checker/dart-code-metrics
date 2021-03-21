import 'package:meta/meta.dart';
import 'package:source_span/source_span.dart';

import 'entity_type.dart';

/// Represents any metric documentation
@immutable
class MetricDocumentation {
  /// The name of a metric
  final String name;

  /// The short name of a metric
  final String shortName;

  /// The short message with formal statement about metric
  final String brief;

  /// Which type of entities will be measured by a metric
  final EntityType measuredType;

  /// Code snippets that we use when generating documentation for a metric
  final Iterable<SourceSpan> examples;

  /// Initialize a newly created [MetricDocumentation].
  ///
  /// This data object helps us to generate documentation from source code.
  const MetricDocumentation({
    @required this.name,
    @required this.shortName,
    @required this.brief,
    @required this.measuredType,
    @required this.examples,
  });
}
