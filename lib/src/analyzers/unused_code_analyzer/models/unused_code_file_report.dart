import '../../../reporters/models/file_report.dart';
import 'unused_code_issue.dart';

/// Represents unused code report collected for a file.
class UnusedCodeFileReport implements FileReport {
  /// The path to the target file.
  @override
  final String path;

  /// The path to the target file relative to the package root.
  @override
  final String relativePath;

  /// The issues detected in the target file.
  final Iterable<UnusedCodeIssue> issues;

  const UnusedCodeFileReport({
    required this.path,
    required this.relativePath,
    required this.issues,
  });
}
