import 'package:source_span/source_span.dart';

/// Represents an issue detected by the unused localization check.
class UnusedL10nIssue {
  /// The name of a class member, which is unused.
  final String memberName;

  /// The source location associated with this issue.
  final SourceLocation location;

  /// Initialize a newly created [UnusedL10nIssue].
  ///
  /// The issue is associated with the given [location]. Used for
  /// creating an unused localization report.
  const UnusedL10nIssue({
    required this.memberName,
    required this.location,
  });
}
