import '../../cli/models/parsed_arguments.dart';
import '../../config_builder/analysis_options_utils.dart';
import '../../config_builder/models/analysis_options.dart';
import 'metrics/metrics_factory.dart';

/// Represents raw lint config which can be merged with other raw configs.
class LintConfig {
  final Iterable<String> excludePatterns;
  final Iterable<String> excludeForMetricsPatterns;
  final Map<String, Object> metrics;
  final Map<String, Map<String, Object>> rules;
  final Iterable<String> excludeForRulesPatterns;
  final Map<String, Map<String, Object>> antiPatterns;

  const LintConfig({
    required this.excludePatterns,
    required this.excludeForMetricsPatterns,
    required this.metrics,
    required this.rules,
    required this.excludeForRulesPatterns,
    required this.antiPatterns,
  });

  /// Creates the config from analysis [options].
  factory LintConfig.fromAnalysisOptions(AnalysisOptions options) {
    const _rootKey = 'dart_code_metrics';

    return LintConfig(
      excludePatterns: options.readIterableOfString(['analyzer', 'exclude']),
      excludeForMetricsPatterns:
          options.readIterableOfString([_rootKey, 'metrics-exclude']),
      metrics: options.readMap([_rootKey, 'metrics']),
      rules: options.readMapOfMap([_rootKey, 'rules']),
      excludeForRulesPatterns:
          options.readIterableOfString([_rootKey, 'rules-exclude']),
      antiPatterns: options.readMapOfMap([_rootKey, 'anti-patterns']),
    );
  }

  /// Creates the config from cli [arguments].
  factory LintConfig.fromArgs(ParsedArguments arguments) => LintConfig(
        excludePatterns:
            arguments.excludePath.isNotEmpty ? [arguments.excludePath] : [],
        excludeForMetricsPatterns: const [],
        metrics: {
          for (final metric in getMetrics(config: {}))
            if (arguments.metricsConfig.containsKey(metric.id))
              metric.id: arguments.metricsConfig[metric.id]!,
        },
        rules: const {},
        excludeForRulesPatterns: const [],
        antiPatterns: const {},
      );

  /// Merges two configs into a single one
  ///
  /// Config coming from [overrides] has a higher priority
  /// and overrides conflicting entries.
  LintConfig merge(LintConfig overrides) => LintConfig(
        excludePatterns: {...excludePatterns, ...overrides.excludePatterns},
        excludeForMetricsPatterns: {
          ...excludeForMetricsPatterns,
          ...overrides.excludeForMetricsPatterns,
        },
        metrics: mergeMaps(defaults: metrics, overrides: overrides.metrics),
        rules: mergeMaps(defaults: rules, overrides: overrides.rules)
            .cast<String, Map<String, Object>>(),
        excludeForRulesPatterns: {
          ...excludeForRulesPatterns,
          ...overrides.excludeForRulesPatterns,
        },
        antiPatterns:
            mergeMaps(defaults: antiPatterns, overrides: overrides.antiPatterns)
                .cast<String, Map<String, Object>>(),
      );
}
