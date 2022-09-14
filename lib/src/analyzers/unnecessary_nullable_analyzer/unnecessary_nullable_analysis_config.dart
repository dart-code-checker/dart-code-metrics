import 'package:glob/glob.dart';

/// Represents converted unused code config which contains parsed entities.
class UnnecessaryNullableAnalysisConfig {
  final Iterable<Glob> globalExcludes;

  const UnnecessaryNullableAnalysisConfig(this.globalExcludes);
}
