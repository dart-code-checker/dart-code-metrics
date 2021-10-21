import '../../models/severity.dart';
import 'rule.dart';
import 'rule_documentation.dart';
import 'rule_type.dart';

/// Represents a base class for Flutter-specific rules.
abstract class FlutterRule extends Rule {
  const FlutterRule({
    required String id,
    required RuleDocumentation documentation,
    required Severity severity,
    required Iterable<String> excludes,
  }) : super(
          id: id,
          type: RuleType.flutter,
          documentation: documentation,
          severity: severity,
          excludes: excludes,
        );
}
