import '../../models/severity.dart';
import 'rule.dart';
import 'rule_type.dart';

/// Represents a base class for intl-specific rules.
abstract class IntlRule extends Rule {
  const IntlRule({
    required String id,
    required Severity severity,
    required Iterable<String> excludes,
  }) : super(
          id: id,
          type: RuleType.intl,
          severity: severity,
          excludes: excludes,
        );
}
