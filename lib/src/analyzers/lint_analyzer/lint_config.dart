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
  final bool shouldPrintConfig;
  final String? analysisOptionsPath;

  const LintConfig({
    required this.excludePatterns,
    required this.excludeForMetricsPatterns,
    required this.metrics,
    required this.rules,
    required this.excludeForRulesPatterns,
    required this.antiPatterns,
    required this.shouldPrintConfig,
    required this.analysisOptionsPath,
  });

  /// Creates the config from analysis [options].
  factory LintConfig.fromAnalysisOptions(AnalysisOptions options) => LintConfig(
        excludePatterns: options.readIterableOfString(['analyzer', 'exclude']),
        excludeForMetricsPatterns: options
            .readIterableOfString(['metrics-exclude'], packageRelated: true),
        metrics: options.readMap(['metrics'], packageRelated: true),
        rules: options.readMapOfMap(['rules'], packageRelated: true),
        excludeForRulesPatterns: options
            .readIterableOfString(['rules-exclude'], packageRelated: true),
        antiPatterns:
            options.readMapOfMap(['anti-patterns'], packageRelated: true),
        shouldPrintConfig: false,
        analysisOptionsPath: options.fullPath,
      );

  /// Creates the config from cli [arguments].
  factory LintConfig.fromArgs(ParsedArguments arguments) => LintConfig(
        shouldPrintConfig: arguments.shouldPrintConfig,
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
        analysisOptionsPath: null,
      );

  /// Merges two configs into a single one
  ///
  /// Config coming from [overrides] has a higher priority
  /// and overrides conflicting entries.
  LintConfig merge(LintConfig overrides) => LintConfig(
        shouldPrintConfig: shouldPrintConfig || overrides.shouldPrintConfig,
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
        analysisOptionsPath:
            analysisOptionsPath ?? overrides.analysisOptionsPath,
      );
}
