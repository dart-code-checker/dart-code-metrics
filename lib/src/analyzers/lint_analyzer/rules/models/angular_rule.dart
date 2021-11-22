import '../../models/severity.dart';
import 'rule.dart';
import 'rule_type.dart';

/// Represents a base class for angular-specific rules.
abstract class AngularRule extends Rule {
  const AngularRule({
    required String id,
    required Severity severity,
    required Iterable<String> excludes,
  }) : super(
          id: id,
          type: RuleType.angular,
          severity: severity,
          excludes: excludes,
        );
}
