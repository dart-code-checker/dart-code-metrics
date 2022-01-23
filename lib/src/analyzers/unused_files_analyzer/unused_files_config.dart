import '../../config_builder/models/analysis_options.dart';

/// Represents raw unused files config which can be merged with other raw configs.
class UnusedFilesConfig {
  final Iterable<String> excludePatterns;
  final Iterable<String> analyzerExcludePatterns;

  const UnusedFilesConfig({
    required this.excludePatterns,
    required this.analyzerExcludePatterns,
  });

  /// Creates the config from analysis [options].
  factory UnusedFilesConfig.fromAnalysisOptions(AnalysisOptions options) =>
      UnusedFilesConfig(
        excludePatterns: const [],
        analyzerExcludePatterns:
            options.readIterableOfString(['analyzer', 'exclude']),
      );

  /// Creates the config from cli args.
  factory UnusedFilesConfig.fromArgs(Iterable<String> excludePatterns) =>
      UnusedFilesConfig(
        excludePatterns: excludePatterns,
        analyzerExcludePatterns: const [],
      );

  /// Merges two configs into a single one.
  ///
  /// Config coming from [overrides] has a higher priority
  /// and overrides conflicting entries.
  UnusedFilesConfig merge(UnusedFilesConfig overrides) => UnusedFilesConfig(
        excludePatterns: {...excludePatterns, ...overrides.excludePatterns},
        analyzerExcludePatterns: {
          ...analyzerExcludePatterns,
          ...overrides.analyzerExcludePatterns,
        },
      );
}
