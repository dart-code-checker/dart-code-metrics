import '../../models/rule_documentation.dart';
import '../../models/severity.dart';
import '../../rules/rule.dart';

abstract class ObsoleteRule extends Rule {
  const ObsoleteRule({
    required String id,
    required Severity severity,
    required Iterable<String> excludes,
  }) : super(
          id: id,
          documentation: const RuleDocumentation(name: '', brief: ''),
          severity: severity,
          excludes: excludes,
        );
}
