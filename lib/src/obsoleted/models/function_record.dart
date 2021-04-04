import 'package:meta/meta.dart';
import 'package:source_span/source_span.dart';

import '../../models/metric_value.dart';
import '../../models/report.dart';

@immutable
class FunctionRecord extends Report {
  const FunctionRecord({
    required SourceSpan location,
    required Iterable<MetricValue<num>> metrics,
  }) : super(location: location, metrics: metrics);
}
