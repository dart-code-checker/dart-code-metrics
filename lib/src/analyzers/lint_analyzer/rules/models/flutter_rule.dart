import 'rule.dart';
import 'rule_type.dart';

/// Represents a base class for Flutter-specific rules.
abstract class FlutterRule extends Rule {
  const FlutterRule({
    required super.id,
    required super.severity,
    required super.excludes,
  }) : super(
          type: RuleType.flutter,
        );
}
