import '../../../reporters/models/file_report.dart';
import 'issue.dart';
import 'report.dart';

/// Represents the metrics report collected for a file.
class LintFileReport implements FileReport {
  /// The path to the target file.
  @override
  final String path;

  /// The path to the target file relative to the package root.
  @override
  final String relativePath;

  /// The metrics report about the target file.
  final Report? file;

  /// The all classes reports in the target file.
  final Map<String, Report> classes;

  /// The all functions / methods reports in the target file.
  final Map<String, Report> functions;

  /// The issues detected in the target file.
  final Iterable<Issue> issues;

  /// The anti-pattern cases detected in the target file.
  final Iterable<Issue> antiPatternCases;

  const LintFileReport({
    required this.path,
    required this.relativePath,
    required this.file,
    required this.classes,
    required this.functions,
    required this.issues,
    required this.antiPatternCases,
  });

  const LintFileReport.onlyIssues({
    required this.path,
    required this.relativePath,
    required this.issues,
  })  : classes = const {},
        functions = const {},
        antiPatternCases = const {},
        file = null;
}
