import '../../models/rule_documentation.dart';
import '../../models/severity.dart';
import '../../rules/rule.dart';

abstract class ObsoleteRule extends Rule {
  final Uri documentationUrl;

  ObsoleteRule({
    required String id,
    required this.documentationUrl,
    required Severity severity,
  }) : super(
          id: id,
          documentation: const RuleDocumentation(name: '', brief: ''),
          severity: severity,
        );
}
