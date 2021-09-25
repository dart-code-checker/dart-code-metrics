import '../../models/internal_resolved_unit_result.dart';
import '../../models/issue.dart';
import '../../models/report.dart';
import '../../models/scoped_class_declaration.dart';
import '../../models/scoped_function_declaration.dart';
import '../../models/severity.dart';
import 'pattern_documentation.dart';

/// An interface to communicate with a patterns
///
/// All patterns must implement from this interface.
abstract class Pattern {
  /// The id of the pattern.
  final String id;

  /// The documentation associated with the pattern.
  final PatternDocumentation documentation;

  /// The severity of issues emitted by the pattern.
  final Severity severity;

  /// Metric ids which values are used by the anti-pattern to detect a violation.
  Iterable<String> get dependentMetricIds;

  const Pattern({
    required this.id,
    required this.documentation,
    required this.severity,
  });

  /// Returns [Iterable] with [Issue]'s detected while check the passed [source].
  Iterable<Issue> check(
    InternalResolvedUnitResult source,
    Map<ScopedClassDeclaration, Report> classMetrics,
    Map<ScopedFunctionDeclaration, Report> functionMetrics,
  );
}
