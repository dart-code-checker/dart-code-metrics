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
          455,
          585,
          626,
          679,
          792,
          849,
          1121,
          1145,
          1210,
          1236,
          1311,
          1398,
          1481,
          2438,
          2495,
        ],
        startLines: [
          22,
          30,
          32,
          35,
          40,
          43,
          56,
          57,
          63,
          65,
          68,
          71,
          74,
          135,
          138,
        ],
        startColumns: [5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 3, 3],
        endOffsets: [
          470,
          612,
          641,
          700,
          809,
          872,
          1132,
          1157,
          1222,
          1262,
          1343,
          1428,
          1517,
          2449,
          2522,
        ],
        locationTexts: [
          'list.remove(1);',
          '(list..sort()).contains(1);',
          'futureMethod();',
          'await futureMethod();',
          'futureOrMethod();',
          'await futureOrMethod();',
          'props.name;',
          'props.value;',
          'props.field;',
          'props.futureMixinMethod();',
          'await props.futureMixinMethod();',
          'props.futureExtensionMethod();',
          'await props.futureExtensionMethod();',
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
          'Avoid ignoring return values.',
          'Avoid ignoring return values.',
          'Avoid ignoring return values.',
          'Avoid ignoring return values.',
        ],
      );
    });
  });
}
