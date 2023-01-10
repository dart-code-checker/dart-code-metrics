import '../../models/internal_resolved_unit_result.dart';
import '../../models/issue.dart';
import '../../models/severity.dart';
import 'rule_type.dart';

/// An interface to communicate with a rules
///
/// All rules must implement from this interface.
abstract class Rule {
  /// The id of the rule.
  final String id;

  /// The type of the rule.
  final RuleType type;

  /// The severity of issues emitted by the rule.
  final Severity severity;

  /// A list of excluded files for the rule.
  final Iterable<String> excludes;

  /// A list of excluded files for the rule. If empty, all files considered included.
  final Iterable<String> includes;

  /// Initialize a newly created [Rule].
  const Rule({
    required this.id,
    required this.type,
    required this.severity,
    required this.excludes,
    required this.includes,
  });

  bool get requiresConfig => false;

  /// Returns [Iterable] with [Issue]'s detected while check the passed [source]
  Iterable<Issue> check(InternalResolvedUnitResult source);

  Map<String, Object?> toJson() => {
        'id': id,
        'severity': severity.toString(),
        'excludes': excludes.toList(),
      };
}
