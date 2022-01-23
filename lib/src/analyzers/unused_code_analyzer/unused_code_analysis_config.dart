import 'package:glob/glob.dart';

/// Represents converted unused code config which contains parsed entities.
class UnusedCodeAnalysisConfig {
  final Iterable<Glob> globalExcludes;
  final Iterable<Glob> analyzerExcludedPatterns;

  const UnusedCodeAnalysisConfig(
    this.globalExcludes,
    this.analyzerExcludedPatterns,
  );
}
