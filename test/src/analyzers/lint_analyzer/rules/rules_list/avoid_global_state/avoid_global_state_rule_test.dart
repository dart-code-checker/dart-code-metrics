import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/avoid_global_state/avoid_global_state_rule.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _examplePath = 'avoid_global_state/examples/example.dart';

void main() {
  group('AvoidGlobalStateRule', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = AvoidGlobalStateRule().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'avoid-global-state',
        severity: Severity.warning,
      );
    });

    test('reports about found issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = AvoidGlobalStateRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [1, 2, 10, 11, 22, 23, 34, 35],
        startColumns: [5, 5, 15, 18, 15, 18, 15, 18],
        locationTexts: [
          'answer = 42',
          'evenNumbers = [1, 2, 3].where((element) => element.isEven)',
          'a',
          'c',
          'a',
          'c',
          'a',
          'c',
        ],
        messages: [
          'Avoid using global variable without const or final keywords.',
          'Avoid using global variable without const or final keywords.',
          'Avoid using global variable without const or final keywords.',
          'Avoid using global variable without const or final keywords.',
          'Avoid using global variable without const or final keywords.',
          'Avoid using global variable without const or final keywords.',
          'Avoid using global variable without const or final keywords.',
          'Avoid using global variable without const or final keywords.',
        ],
      );
    });
  });
}
