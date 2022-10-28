import 'package:glob/glob.dart';

/// Represents converted unused files config which contains parsed entities.
class UnusedFilesAnalysisConfig {
  final Iterable<Glob> globalExcludes;
  final bool isMonorepo;

  const UnusedFilesAnalysisConfig(
    this.globalExcludes, {
    required this.isMonorepo,
  });

  Map<String, Object?> toJson() => {
        'global-excludes': globalExcludes.map((glob) => glob.pattern).toList(),
        'is-monorepo': isMonorepo,
      };
}
