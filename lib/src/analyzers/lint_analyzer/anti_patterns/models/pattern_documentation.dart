import 'package:meta/meta.dart';

/// Represents any pattern documentation
@immutable
class PatternDocumentation {
  /// The name of the pattern
  final String name;

  /// The short message with formal statement about the pattern
  final String brief;

  /// Initialize a newly created [PatternDocumentation].
  ///
  /// This data object is used for a documentation generating from a source code.
  const PatternDocumentation({
    required this.name,
    required this.brief,
  });
}
