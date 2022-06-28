import 'package:source_span/source_span.dart';

/// Represents an issue detected by the unused code check.
class UnnecessaryNullableIssue {
  /// The name of the unused declaration.
  final String declarationName;

  /// The type of the unused declaration.
  final String declarationType;

  final Iterable<String> parameters;

  /// The source location associated with this issue.
  final SourceLocation location;

  /// Initialize a newly created [UnnecessaryNullableIssue].
  ///
  /// The issue is associated with the given [location]. Used for
  /// creating an unused code report.
  const UnnecessaryNullableIssue({
    required this.declarationName,
    required this.declarationType,
    required this.parameters,
    required this.location,
  });
}
