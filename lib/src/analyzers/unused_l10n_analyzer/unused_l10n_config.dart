import '../../config_builder/models/analysis_options.dart';

/// Represents raw unused files config which can be merged with other raw configs.
class UnusedL10nConfig {
  final Iterable<String> excludePatterns;
  final Iterable<String> analyzerExcludePatterns;
  final String? classPattern;
  final bool shouldPrintConfig;

  const UnusedL10nConfig({
    required this.excludePatterns,
    required this.analyzerExcludePatterns,
    required this.classPattern,
    required this.shouldPrintConfig,
  });

  /// Creates the config from analysis [options].
  factory UnusedL10nConfig.fromAnalysisOptions(
    AnalysisOptions options,
  ) =>
      UnusedL10nConfig(
        excludePatterns: const [],
        analyzerExcludePatterns:
            options.readIterableOfString(['analyzer', 'exclude']),
        classPattern: null,
        shouldPrintConfig: false,
      );

  /// Creates the config from cli args.
  factory UnusedL10nConfig.fromArgs(
    Iterable<String> excludePatterns,
    String classPattern, {
    required bool shouldPrintConfig,
  }) =>
      UnusedL10nConfig(
        shouldPrintConfig: shouldPrintConfig,
        excludePatterns: excludePatterns,
        analyzerExcludePatterns: const [],
        classPattern: classPattern,
      );

  /// Merges two configs into a single one.
  ///
  /// Config coming from [overrides] has a higher priority
  /// and overrides conflicting entries.
  UnusedL10nConfig merge(UnusedL10nConfig overrides) => UnusedL10nConfig(
        excludePatterns: {...excludePatterns, ...overrides.excludePatterns},
        analyzerExcludePatterns: {
          ...analyzerExcludePatterns,
          ...overrides.analyzerExcludePatterns,
        },
        classPattern: overrides.classPattern ?? classPattern,
        shouldPrintConfig: shouldPrintConfig || overrides.shouldPrintConfig,
      );
}
