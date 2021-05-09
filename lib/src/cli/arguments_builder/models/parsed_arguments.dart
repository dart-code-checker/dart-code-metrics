import '../../../analyzers/lint_analyzer/metrics/models/metric_value_level.dart';

class ParsedArguments {
  final String rootFolder;
  final String reporterName;
  final String reportFolder;
  final MetricValueLevel? metricValueLevel;
  final Iterable<String> folders;
  final String exclude;
  final Map<String, Object> metricsConfig;

  const ParsedArguments({
    required this.rootFolder,
    required this.reporterName,
    required this.reportFolder,
    required this.metricValueLevel,
    required this.folders,
    required this.exclude,
    required this.metricsConfig,
  });
}
