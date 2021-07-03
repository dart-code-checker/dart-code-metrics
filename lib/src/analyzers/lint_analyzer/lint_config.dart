import 'package:meta/meta.dart';

import '../../cli/models/parsed_arguments.dart';
import '../../config_builder/analysis_options_utils.dart';
import '../../config_builder/models/analysis_options.dart';
import 'metrics/metrics_factory.dart';

/// Class representing config
@immutable
class LintConfig {
  final Iterable<String> excludePatterns;
  final Iterable<String> excludeForMetricsPatterns;
  final Map<String, Object> metrics;
  final Map<String, Map<String, Object>> rules;
  final Map<String, Map<String, Object>> antiPatterns;

  const LintConfig({
    required this.excludePatterns,
    required this.excludeForMetricsPatterns,
    required this.metrics,
    required this.rules,
    required this.antiPatterns,
  });

  factory LintConfig.fromAnalysisOptions(AnalysisOptions options) {
    const _rootKey = 'dart_code_metrics';

    return LintConfig(
      excludePatterns: options.readIterableOfString(['analyzer', 'exclude']),
      excludeForMetricsPatterns:
          options.readIterableOfString([_rootKey, 'metrics-exclude']),
      metrics: options.readMap([_rootKey, 'metrics']),
      rules: options.readMapOfMap([_rootKey, 'rules']),
      antiPatterns: options.readMapOfMap([_rootKey, 'anti-patterns']),
    );
  }

  factory LintConfig.fromArgs(ParsedArguments arguments) => LintConfig(
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

  LintConfig merge(LintConfig overrides) => LintConfig(
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
