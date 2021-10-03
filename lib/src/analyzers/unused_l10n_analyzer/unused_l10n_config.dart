import 'package:meta/meta.dart';

import '../../config_builder/models/analysis_options.dart';

/// Represents raw unused files config which can be merged with other raw configs.
@immutable
class UnusedL10nConfig {
  final Iterable<String> excludePatterns;
  final Iterable<String> analyzerExcludePatterns;
  final String? classPattern;

  const UnusedL10nConfig({
    required this.excludePatterns,
    required this.analyzerExcludePatterns,
    required this.classPattern,
  });

  factory UnusedL10nConfig.fromAnalysisOptions(
    AnalysisOptions options,
  ) =>
      UnusedL10nConfig(
        excludePatterns: const [],
        analyzerExcludePatterns:
            options.readIterableOfString(['analyzer', 'exclude']),
        classPattern: null,
      );

  factory UnusedL10nConfig.fromArgs(
    Iterable<String> excludePatterns,
    String classPattern,
  ) =>
      UnusedL10nConfig(
        excludePatterns: excludePatterns,
        analyzerExcludePatterns: const [],
        classPattern: classPattern,
      );

  UnusedL10nConfig merge(UnusedL10nConfig overrides) => UnusedL10nConfig(
        excludePatterns: {...excludePatterns, ...overrides.excludePatterns},
        analyzerExcludePatterns: {
          ...analyzerExcludePatterns,
          ...overrides.analyzerExcludePatterns,
        },
        classPattern: overrides.classPattern ?? classPattern,
      );
}
