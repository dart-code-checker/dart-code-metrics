import 'package:analyzer/dart/analysis/results.dart';

import '../models/issue.dart';
import '../models/pattern_documentation.dart';
import '../models/report.dart';

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
  Iterable<Issue> check(ResolvedUnitResult source, Report report);
}
