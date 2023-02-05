import '../../models/internal_resolved_unit_result.dart';
import '../../models/issue.dart';
import '../../models/report.dart';
import '../../models/scoped_class_declaration.dart';
import '../../models/scoped_function_declaration.dart';
import '../../models/severity.dart';

/// An interface to communicate with a patterns
///
/// All patterns must implement from this interface.
abstract class Pattern {
  /// The id of the pattern.
  final String id;

  /// The severity of issues emitted by the pattern.
  final Severity severity;

  /// A list of excluded files for the pattern.
  final Iterable<String> excludes;

  /// Metric ids which values are used by the anti-pattern to detect a violation.
  Iterable<String> get dependentMetricIds;

  const Pattern({
    required this.id,
    required this.severity,
    required this.excludes,
  });

  /// Returns [Iterable] with [Issue]'s detected while check the passed [source].
  Iterable<Issue> check(
    InternalResolvedUnitResult source,
    Map<ScopedClassDeclaration, Report> classMetrics,
    Map<ScopedFunctionDeclaration, Report> functionMetrics,
  );

  Map<String, Object?> toJson() => {
        'id': id,
        'severity': severity.toString(),
        'excludes': excludes.toList(),
        'dependentMetricIds': dependentMetricIds.toList(),
      };
}
