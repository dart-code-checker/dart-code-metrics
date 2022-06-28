import '../../../reporters/models/file_report.dart';
import 'unnecessary_nullable_issue.dart';

/// Represents unused code report collected for a file.
class UnnecessaryNullableFileReport implements FileReport {
  /// The path to the target file.
  @override
  final String path;

  /// The path to the target file relative to the package root.
  @override
  final String relativePath;

  /// The issues detected in the target file.
  final Iterable<UnnecessaryNullableIssue> issues;

  const UnnecessaryNullableFileReport({
    required this.path,
    required this.relativePath,
    required this.issues,
  });
}
