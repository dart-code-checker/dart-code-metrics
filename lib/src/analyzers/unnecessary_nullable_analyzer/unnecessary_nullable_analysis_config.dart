import 'package:glob/glob.dart';

/// Represents converted unused code config which contains parsed entities.
class UnnecessaryNullableAnalysisConfig {
  final Iterable<Glob> globalExcludes;
  final Iterable<Glob> analyzerExcludedPatterns;

  const UnnecessaryNullableAnalysisConfig(
    this.globalExcludes,
    this.analyzerExcludedPatterns,
  );
}
