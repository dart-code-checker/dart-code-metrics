@TestOn('vm')
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/avoid_ignoring_return_values/avoid_ignoring_return_values_rule.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _examplePath = 'avoid_ignoring_return_values/examples/example.dart';

void main() {
  group('AvoidIgnoringReturnValuesRule', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = AvoidIgnoringReturnValuesRule().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'avoid-ignoring-return-values',
        severity: Severity.warning,
      );
    });

    test('reports about found issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = AvoidIgnoringReturnValuesRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startOffsets: [
          256,
          386,
          427,
          480,
          593,
          650,
          922,
          946,
          1010,
          1541,
          1598,
        ],
        startLines: [20, 28, 30, 33, 38, 41, 54, 55, 61, 101, 104],
        startColumns: [5, 5, 5, 5, 5, 5, 5, 5, 5, 3, 3],
        endOffsets: [
          271,
          413,
          442,
          501,
          610,
          673,
          933,
          957,
          1022,
          1552,
          1625,
        ],
        locationTexts: [
          'list.remove(1);',
          '(list..sort()).contains(1);',
          'futureMethod();',
          'await futureMethod();',
          'futureOrMethod();',
          'await futureOrMethod();',
          'props.name;',
          'props.name;',
          'props.field;',
          'function();',
          'SomeService.staticMethod();',
        ],
        messages: [
          'Avoid ignoring return values.',
          'Avoid ignoring return values.',
          'Avoid ignoring return values.',
          'Avoid ignoring return values.',
          'Avoid ignoring return values.',
          'Avoid ignoring return values.',
          'Avoid ignoring return values.',
          'Avoid ignoring return values.',
          'Avoid ignoring return values.',
          'Avoid ignoring return values.',
          'Avoid ignoring return values.',
        ],
      );
    });
  });
}
