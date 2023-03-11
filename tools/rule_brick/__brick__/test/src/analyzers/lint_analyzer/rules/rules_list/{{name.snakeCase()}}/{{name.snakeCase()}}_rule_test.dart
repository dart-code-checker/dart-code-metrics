import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/{{name.snakeCase()}}/{{name.snakeCase()}}_rule.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _examplePath = '{{name.snakeCase()}}/examples/example.dart';

void main() {
  group('{{name.pascalCase()}}Rule', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = {{name.pascalCase()}}Rule().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: '{{name}}',
        severity: Severity.{{severity}},
      );
    });

    test('reports about found issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = {{name.pascalCase()}}Rule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [],
        startColumns: [],
        locationTexts: [],
        messages: [],
      );
    });
  });
}
