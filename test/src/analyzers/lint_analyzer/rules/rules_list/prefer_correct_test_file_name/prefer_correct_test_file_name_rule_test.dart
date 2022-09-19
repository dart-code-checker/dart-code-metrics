import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/prefer_correct_test_file_name/prefer_correct_test_file_name_rule.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _examplePath = 'prefer_correct_test_file_name/examples/example.dart';
const _correctExamplePath =
    'prefer_correct_test_file_name/examples/correct_example.dart';

void main() {
  group('PreferCorrectTestFileNameRule', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = PreferCorrectTestFileNameRule().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'prefer-correct-test-file-name',
        severity: Severity.warning,
      );
    });

    test('reports about found issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final config = {'name-pattern': 'correct_example.dart'};

      final issues = PreferCorrectTestFileNameRule(config).check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [2],
        startColumns: [1],
        locationTexts: [
          'void main() {\n'
              "  print('Hello');\n"
              '}',
        ],
        messages: [
          'Test file name should end with correct_example.dart',
        ],
      );
    });

    test('reports no found issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_correctExamplePath);
      final config = {'name-pattern': 'correct_example.dart'};

      final issues = PreferCorrectTestFileNameRule(config).check(unit);

      RuleTestHelper.verifyNoIssues(issues);
    });
  });
}
