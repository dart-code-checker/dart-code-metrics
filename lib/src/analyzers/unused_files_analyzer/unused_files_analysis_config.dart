import 'package:glob/glob.dart';

class UnusedFilesAnalysisConfig {
  final Iterable<Glob> globalExcludes;
  final Iterable<Glob> analyzerExcludedPatterns;

  const UnusedFilesAnalysisConfig(
    this.globalExcludes,
    this.analyzerExcludedPatterns,
  );
}
