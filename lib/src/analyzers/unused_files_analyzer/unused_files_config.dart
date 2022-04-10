import '../../config_builder/models/analysis_options.dart';

/// Represents raw unused files config which can be merged with other raw configs.
class UnusedFilesConfig {
  final Iterable<String> excludePatterns;
  final Iterable<String> analyzerExcludePatterns;
  final bool isMonorepo;

  const UnusedFilesConfig({
    required this.excludePatterns,
    required this.analyzerExcludePatterns,
    required this.isMonorepo,
  });

  /// Creates the config from analysis [options].
  factory UnusedFilesConfig.fromAnalysisOptions(AnalysisOptions options) =>
      UnusedFilesConfig(
        excludePatterns: const [],
        analyzerExcludePatterns:
            options.readIterableOfString(['analyzer', 'exclude']),
        isMonorepo: false,
      );

  /// Creates the config from cli args.
  factory UnusedFilesConfig.fromArgs(
    Iterable<String> excludePatterns, {
    required bool isMonorepo,
  }) =>
      UnusedFilesConfig(
        excludePatterns: excludePatterns,
        analyzerExcludePatterns: const [],
        isMonorepo: isMonorepo,
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
        isMonorepo: isMonorepo || overrides.isMonorepo,
      );
}
