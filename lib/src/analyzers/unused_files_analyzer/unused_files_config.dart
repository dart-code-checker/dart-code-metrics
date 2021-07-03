import 'package:meta/meta.dart';

import '../../config_builder/models/analysis_options.dart';

/// Class representing config
@immutable
class UnusedFilesConfig {
  final Iterable<String> excludePatterns;
  final Iterable<String> analyzerExcludePatterns;

  const UnusedFilesConfig({
    required this.excludePatterns,
    required this.analyzerExcludePatterns,
  });

  factory UnusedFilesConfig.fromAnalysisOptions(AnalysisOptions options) =>
      UnusedFilesConfig(
        excludePatterns: const [],
        analyzerExcludePatterns:
            options.readIterableOfString(['analyzer', 'exclude']),
      );

  factory UnusedFilesConfig.fromArgs(Iterable<String> excludePatterns) =>
      UnusedFilesConfig(
        excludePatterns: excludePatterns,
        analyzerExcludePatterns: const [],
      );

  UnusedFilesConfig merge(UnusedFilesConfig overrides) => UnusedFilesConfig(
        excludePatterns: {...excludePatterns, ...overrides.excludePatterns},
        analyzerExcludePatterns: {
          ...analyzerExcludePatterns,
          ...overrides.analyzerExcludePatterns,
        },
      );
}
