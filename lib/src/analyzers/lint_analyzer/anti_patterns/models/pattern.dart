import '../../models/internal_resolved_unit_result.dart';
import '../../models/issue.dart';
import '../../models/report.dart';
import 'pattern_documentation.dart';

/// An interface to communicate with a patterns
///
/// All patterns must implement from this interface.
abstract class Pattern {
  /// The id of the pattern.
  final String id;

  /// The documentation associated with the pattern
  final PatternDocumentation documentation;

  const Pattern({
    required this.id,
    required this.documentation,
  });

  /// Returns [Iterable] with [Issue]'s detected while check the passed [source]
  Iterable<Issue> check(InternalResolvedUnitResult source, Report report);
}
