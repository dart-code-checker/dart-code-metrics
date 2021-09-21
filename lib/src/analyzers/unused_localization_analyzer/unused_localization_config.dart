import 'package:meta/meta.dart';

import '../../config_builder/models/analysis_options.dart';

/// Represents raw unused files config which can be merged with other raw configs.
@immutable
class UnusedLocalizationConfig {
  final Iterable<String> excludePatterns;
  final Iterable<String> analyzerExcludePatterns;
  final String? classPattern;

  const UnusedLocalizationConfig({
    required this.excludePatterns,
    required this.analyzerExcludePatterns,
    required this.classPattern,
  });

  factory UnusedLocalizationConfig.fromAnalysisOptions(
    AnalysisOptions options,
  ) =>
      UnusedLocalizationConfig(
        excludePatterns: const [],
        analyzerExcludePatterns:
            options.readIterableOfString(['analyzer', 'exclude']),
        classPattern: null,
      );

  factory UnusedLocalizationConfig.fromArgs(
    Iterable<String> excludePatterns,
    String classPattern,
  ) =>
      UnusedLocalizationConfig(
        excludePatterns: excludePatterns,
        analyzerExcludePatterns: const [],
        classPattern: classPattern,
      );

  UnusedLocalizationConfig merge(UnusedLocalizationConfig overrides) =>
      UnusedLocalizationConfig(
        excludePatterns: {...excludePatterns, ...overrides.excludePatterns},
        analyzerExcludePatterns: {
          ...analyzerExcludePatterns,
          ...overrides.analyzerExcludePatterns,
        },
        classPattern: overrides.classPattern ?? classPattern,
      );
}
