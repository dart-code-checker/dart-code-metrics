import 'package:glob/glob.dart';

/// Represents converted unused files config which contains parsed entities.
class UnusedFilesAnalysisConfig {
  final Iterable<Glob> globalExcludes;
  final Iterable<Glob> analyzerExcludedPatterns;

  const UnusedFilesAnalysisConfig(
    this.globalExcludes,
    this.analyzerExcludedPatterns,
  );
}
