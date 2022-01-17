import 'package:source_span/source_span.dart';

/// Represents an issue detected by the unused code check.
class UnusedCodeIssue {
  /// The name of the unused declaration.
  final String declarationName;

  /// The type of the unused declaration.
  final String declarationType;

  /// The source location associated with this issue.
  final SourceLocation location;

  /// Initialize a newly created [UnusedCodeIssue].
  ///
  /// The issue is associated with the given [location]. Used for
  /// creating an unused code report.
  const UnusedCodeIssue({
    required this.declarationName,
    required this.declarationType,
    required this.location,
  });
}
