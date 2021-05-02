import '../../../models/severity.dart';
import 'rule.dart';
import 'rule_documentation.dart';

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
