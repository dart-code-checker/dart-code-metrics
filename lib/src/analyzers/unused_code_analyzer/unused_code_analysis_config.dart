import 'package:glob/glob.dart';

/// Represents converted unused code config which contains parsed entities.
class UnusedCodeAnalysisConfig {
  final Iterable<Glob> globalExcludes;

  const UnusedCodeAnalysisConfig(this.globalExcludes);
}
