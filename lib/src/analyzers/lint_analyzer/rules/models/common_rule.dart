import '../../models/severity.dart';
import 'rule.dart';
import 'rule_type.dart';

/// Represents a base class for common rules.
abstract class CommonRule extends Rule {
  const CommonRule({
    required String id,
    required Severity severity,
    required Iterable<String> excludes,
  }) : super(
          id: id,
          type: RuleType.common,
          severity: severity,
          excludes: excludes,
        );
}
