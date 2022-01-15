import 'package:meta/meta.dart';

import '../../config_builder/models/analysis_options.dart';

/// Represents raw unused code config which can be merged with other raw configs.
@immutable
class UnusedCodeConfig {
  final Iterable<String> excludePatterns;
  final Iterable<String> analyzerExcludePatterns;

  const UnusedCodeConfig({
    required this.excludePatterns,
    required this.analyzerExcludePatterns,
  });

  /// Creates the config from analysis [options].
  factory UnusedCodeConfig.fromAnalysisOptions(AnalysisOptions options) =>
      UnusedCodeConfig(
        excludePatterns: const [],
        analyzerExcludePatterns:
            options.readIterableOfString(['analyzer', 'exclude']),
      );

  /// Creates the config from cli args.
  factory UnusedCodeConfig.fromArgs(Iterable<String> excludePatterns) =>
      UnusedCodeConfig(
        excludePatterns: excludePatterns,
        analyzerExcludePatterns: const [],
      );

  /// Merges two configs into a single one.
  ///
  /// Config coming from [overrides] has a higher priority
  /// and overrides conflicting entries.
  UnusedCodeConfig merge(UnusedCodeConfig overrides) => UnusedCodeConfig(
        excludePatterns: {...excludePatterns, ...overrides.excludePatterns},
        analyzerExcludePatterns: {
          ...analyzerExcludePatterns,
          ...overrides.analyzerExcludePatterns,
        },
      );
}
