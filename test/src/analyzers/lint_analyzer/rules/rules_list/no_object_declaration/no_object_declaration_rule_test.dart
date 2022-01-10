import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/no_object_declaration/no_object_declaration_rule.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _examplePath = 'no_object_declaration/examples/example.dart';

void main() {
  group('NoObjectDeclarationRule', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = NoObjectDeclarationRule().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'no-object-declaration',
        severity: Severity.style,
      );
    });

    test('reports about found issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = NoObjectDeclarationRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [2, 4, 7],
        startColumns: [3, 3, 3],
        locationTexts: [
          'Object data = 1;',
          'Object get getter => 1;',
          'Object doWork() {\n'
              '    return null;\n'
              '  }',
        ],
        messages: [
          'Avoid Object type declaration in class member.',
          'Avoid Object type declaration in class member.',
          'Avoid Object type declaration in class member.',
        ],
      );
    });
  });
}
