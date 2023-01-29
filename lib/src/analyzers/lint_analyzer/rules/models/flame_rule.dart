import 'rule.dart';
import 'rule_type.dart';

/// Represents a base class for Flutter-specific rules.
abstract class FlameRule extends Rule {
  static const link = 'https://pub.dev/packages/flame';

  const FlameRule({
    required super.id,
    required super.severity,
    required super.excludes,
    required super.includes,
  }) : super(
          type: RuleType.flame,
        );
}
