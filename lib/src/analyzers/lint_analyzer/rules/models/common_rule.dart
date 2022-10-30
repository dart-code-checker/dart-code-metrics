import 'rule.dart';
import 'rule_type.dart';

/// Represents a base class for common rules.
abstract class CommonRule extends Rule {
  const CommonRule({
    required super.id,
    required super.severity,
    required super.excludes,
    required super.includes,
  }) : super(
          type: RuleType.common,
        );
}
