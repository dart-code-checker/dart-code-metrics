import 'package:meta/meta.dart';

/// Represents a report collected for a file.
@immutable
abstract class FileReport {
  /// The path to the target file.
  final String path;

  /// The path to the target file relative to the package root.
  final String relativePath;

  const FileReport({
    required this.path,
    required this.relativePath,
  });
}
