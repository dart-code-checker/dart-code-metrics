import 'package:source_span/source_span.dart';

import '../../../reporters/models/file_report.dart';

class UnusedLocalizationFileReport implements FileReport {
  /// The path to the target file.
  @override
  final String path;

  /// The path to the target file relative to the package root.
  @override
  final String relativePath;

  final Iterable<SourceSpan> unusedMembersLocation;

  final String className;

  const UnusedLocalizationFileReport({
    required this.path,
    required this.relativePath,
    required this.unusedMembersLocation,
    required this.className,
  });
}
