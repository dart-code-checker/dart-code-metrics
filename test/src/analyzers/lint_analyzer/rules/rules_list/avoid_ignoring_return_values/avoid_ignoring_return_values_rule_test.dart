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
          759,
          916,
          973,
          1245,
          1269,
          1334,
          1360,
          1537,
          1679,
          1872,
          2888,
          2945,
        ],
        startLines: [
          22,
          30,
          32,
          37,
          43,
          46,
          59,
          60,
          66,
          68,
          73,
          77,
          82,
          144,
          147,
        ],
        startColumns: [5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 3, 3],
        endOffsets: [
          470,
          612,
          641,
          780,
          933,
          996,
          1256,
          1281,
          1346,
          1386,
          1569,
          1709,
          1908,
          2899,
          2972,
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
