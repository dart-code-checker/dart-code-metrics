import '../../../reporters/models/file_report.dart';
import 'unused_l10n_issue.dart';

/// Represents unused localization report collected for a file.
class UnusedL10nFileReport implements FileReport {
  /// The path to the target file.
  @override
  final String path;

  /// The path to the target file relative to the package root.
  @override
  final String relativePath;

  /// The issues detected in the target file.
  final Iterable<UnusedL10nIssue> issues;

  /// The name of a class with issues.
  final String className;

  const UnusedL10nFileReport({
    required this.path,
    required this.relativePath,
    required this.issues,
    required this.className,
  });
}
