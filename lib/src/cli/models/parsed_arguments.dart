import 'package:meta/meta.dart';

import '../../analyzers/lint_analyzer/metrics/models/metric_value_level.dart';

@immutable
class ParsedArguments {
  final String rootFolder;
  final String reporterName;
  final String reportFolder;
  final MetricValueLevel? maximumAllowedLevel;
  final Iterable<String> folders;
  final String excludePath;
  final Map<String, Object> metricsConfig;

  const ParsedArguments({
    required this.rootFolder,
    required this.reporterName,
    required this.reportFolder,
    required this.maximumAllowedLevel,
    required this.folders,
    required this.excludePath,
    required this.metricsConfig,
  });
}
