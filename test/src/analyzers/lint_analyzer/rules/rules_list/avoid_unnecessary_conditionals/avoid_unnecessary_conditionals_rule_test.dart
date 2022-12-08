import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/avoid_unnecessary_conditionals/avoid_unnecessary_conditionals_rule.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _examplePath = 'avoid_unnecessary_conditionals/examples/example.dart';

void main() {
  group('AvoidUnnecessaryConditionalsRule', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = AvoidUnnecessaryConditionalsRule().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'avoid-unnecessary-conditionals',
        severity: Severity.warning,
      );
    });

    test('reports about found issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = AvoidUnnecessaryConditionalsRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [7, 13, 16, 18],
        startColumns: [19, 10, 15, 15],
        locationTexts: [
          'str.isEmpty ? true : false',
          'str.isEmpty ? false : true',
          'foo ? false : true',
          'foo ? true : false',
        ],
        messages: [
          'Avoid unnecessary conditional expressions.',
          'Avoid unnecessary conditional expressions.',
          'Avoid unnecessary conditional expressions.',
          'Avoid unnecessary conditional expressions.',
        ],
        replacements: [
          'str.isEmpty',
          '!str.isEmpty',
          '!foo',
          'foo',
        ],
        replacementComments: [
          'Remove unnecessary conditional expression.',
          'Remove unnecessary conditional expression.',
          'Remove unnecessary conditional expression.',
          'Remove unnecessary conditional expression.',
        ],
      );
    });
  });
}
