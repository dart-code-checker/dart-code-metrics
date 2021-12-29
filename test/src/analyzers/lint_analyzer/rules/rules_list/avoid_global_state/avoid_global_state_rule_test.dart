@TestOn('vm')
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
        startOffsets: [4, 29],
        startLines: [1, 2],
        startColumns: [5, 5],
        endOffsets: [15, 87],
        locationTexts: [
          'answer = 42',
          'evenNumbers = [1, 2, 3].where((element) => element.isEven)',
        ],
        messages: [
          'Avoid use global variable without const or final keywords.',
          'Avoid use global variable without const or final keywords.',
        ],
      );
    });
  });
}
