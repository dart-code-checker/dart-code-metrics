import 'package:glob/glob.dart';

/// Represents converted unused files config which contains parsed entities.
class UnusedLocalizationAnalysisConfig {
  final Iterable<Glob> globalExcludes;
  final Iterable<Glob> analyzerExcludedPatterns;
  final RegExp classPattern;

  UnusedLocalizationAnalysisConfig(
    this.globalExcludes,
    this.analyzerExcludedPatterns,
    String? classPattern,
  ) : classPattern = RegExp(classPattern ?? r'I18n$');
}
