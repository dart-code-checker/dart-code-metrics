import 'package:meta/meta.dart';

import '../../analyzers/lint_analyzer/metrics/metrics_factory.dart';
import '../../cli/models/parsed_arguments.dart';
import '../analysis_options_utils.dart';
import 'analysis_options.dart';

/// Class representing config
@immutable
class Config {
  final Iterable<String> excludePatterns;
  final Iterable<String> excludeForMetricsPatterns;
  final Map<String, Object> metrics;
  final Map<String, Map<String, Object>> rules;
  final Map<String, Map<String, Object>> antiPatterns;

  const Config({
    required this.excludePatterns,
    required this.excludeForMetricsPatterns,
    required this.metrics,
    required this.rules,
    required this.antiPatterns,
  });

  factory Config.fromAnalysisOptions(AnalysisOptions options) {
    const _rootKey = 'dart_code_metrics';

    return Config(
      excludePatterns: options.readIterableOfString(['analyzer', 'exclude']),
      excludeForMetricsPatterns:
          options.readIterableOfString([_rootKey, 'metrics-exclude']),
      metrics: options.readMap([_rootKey, 'metrics']),
      rules: options.readMapOfMap([_rootKey, 'rules']),
      antiPatterns: options.readMapOfMap([_rootKey, 'anti-patterns']),
    );
  }

  factory Config.fromArgs(ParsedArguments arguments) => Config(
        excludePatterns: [arguments.excludePath],
        excludeForMetricsPatterns: const [],
        metrics: {
          for (final metric in getMetrics(config: {}))
            if (arguments.metricsConfig.containsKey(metric.id))
              metric.id: arguments.metricsConfig[metric.id]!,
        },
        rules: const {},
        antiPatterns: const {},
      );

  Config merge(Config overrides) => Config(
        excludePatterns: {...excludePatterns, ...overrides.excludePatterns},
        excludeForMetricsPatterns: {
          ...excludeForMetricsPatterns,
          ...overrides.excludeForMetricsPatterns,
        },
        metrics: mergeMaps(defaults: metrics, overrides: overrides.metrics),
        rules: mergeMaps(defaults: rules, overrides: overrides.rules)
            .cast<String, Map<String, Object>>(),
        antiPatterns:
            mergeMaps(defaults: antiPatterns, overrides: overrides.antiPatterns)
                .cast<String, Map<String, Object>>(),
      );
}
