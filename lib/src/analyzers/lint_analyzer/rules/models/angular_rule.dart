import '../../models/severity.dart';
import 'rule.dart';
import 'rule_documentation.dart';
import 'rule_type.dart';

abstract class AngularRule extends Rule {
  const AngularRule({
    required String id,
    required RuleDocumentation documentation,
    required Severity severity,
    required Iterable<String> excludes,
  }) : super(
          id: id,
          type: RuleType.angular,
          documentation: documentation,
          severity: severity,
          excludes: excludes,
        );
}
