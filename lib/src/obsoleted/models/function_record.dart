import 'package:meta/meta.dart';
import 'package:source_span/source_span.dart';

import '../../models/metric_value.dart';
import '../../models/report.dart';

@immutable
class FunctionRecord extends Report {
  final Map<int, int> cyclomaticComplexityLines;

  final Map<String, int> operators;
  final Map<String, int> operands;

  const FunctionRecord({
    required SourceSpan location,
    required Iterable<MetricValue<num>> metrics,
    required this.cyclomaticComplexityLines,
    required this.operators,
    required this.operands,
  }) : super(location: location, metrics: metrics);
}
