import 'package:meta/meta.dart';

/// Represents any rule documentation
@immutable
class RuleDocumentation {
  /// The name of a rule
  final String name;

  /// The short message with formal statement about rule
  final String brief;

  /// Initialize a newly created [RuleDocumentation].
  ///
  /// This data object is used for a documentation generating from a source code.
  const RuleDocumentation({
    @required this.name,
    @required this.brief,
  });
}
