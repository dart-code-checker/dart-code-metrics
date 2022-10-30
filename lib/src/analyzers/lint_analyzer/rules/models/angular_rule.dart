import 'rule.dart';
import 'rule_type.dart';

/// Represents a base class for angular-specific rules.
abstract class AngularRule extends Rule {
  const AngularRule({
    required super.id,
    required super.severity,
    required super.excludes,
    required super.includes,
  }) : super(
          type: RuleType.angular,
        );
}
