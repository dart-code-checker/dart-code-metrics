import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/use_setstate_synchronously/use_setstate_synchronously_rule.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _examplePath = 'use_setstate_synchronously/examples/example.dart';
const _issuesPath = 'use_setstate_synchronously/examples/known_errors.dart';
const _trySwitchPath =
    'use_setstate_synchronously/examples/extras_try_switch.dart';
const _contextMountedPath =
    'use_setstate_synchronously/examples/context_mounted.dart';
const _assertExample =
    'use_setstate_synchronously/examples/assert_example.dart';

void main() {
  group('UseSetStateSynchronouslyTest', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = UseSetStateSynchronouslyRule().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'use-setstate-synchronously',
        severity: Severity.warning,
      );
    });

    test('reports about found issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = UseSetStateSynchronouslyRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [7, 24, 29, 36, 51, 66, 70, 76, 82, 92, 97, 102],
        startColumns: [9, 10, 7, 7, 5, 7, 5, 5, 5, 5, 5, 7],
        locationTexts: [
          'setState',
          'setState',
          'setState',
          'setState',
          'setState',
          'setState',
          'setState',
          'setState',
          'setState',
          'setState',
          'setState',
          'setState',
        ],
        messages: [
          "Avoid calling 'setState' past an await point without checking if the widget is mounted.",
          "Avoid calling 'setState' past an await point without checking if the widget is mounted.",
          "Avoid calling 'setState' past an await point without checking if the widget is mounted.",
          "Avoid calling 'setState' past an await point without checking if the widget is mounted.",
          "Avoid calling 'setState' past an await point without checking if the widget is mounted.",
          "Avoid calling 'setState' past an await point without checking if the widget is mounted.",
          "Avoid calling 'setState' past an await point without checking if the widget is mounted.",
          "Avoid calling 'setState' past an await point without checking if the widget is mounted.",
          "Avoid calling 'setState' past an await point without checking if the widget is mounted.",
          "Avoid calling 'setState' past an await point without checking if the widget is mounted.",
          "Avoid calling 'setState' past an await point without checking if the widget is mounted.",
          "Avoid calling 'setState' past an await point without checking if the widget is mounted.",
        ],
      );
    });

    test('reports known issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_issuesPath);
      final issues = UseSetStateSynchronouslyRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [4],
        startColumns: [5],
        locationTexts: ['setState'],
        messages: [
          "Avoid calling 'setState' past an await point without checking if the widget is mounted.",
        ],
      );
    });

    test('reports issues with custom config', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final config = {
        'methods': ['foobar'],
      };
      final issues = UseSetStateSynchronouslyRule(config).check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [16, 17],
        startColumns: [5, 10],
        locationTexts: ['foobar', 'foobar'],
        messages: [
          "Avoid calling 'foobar' past an await point without checking if the widget is mounted.",
          "Avoid calling 'foobar' past an await point without checking if the widget is mounted.",
        ],
      );
    });

    test('reports issues with try- and switch-statements', () async {
      final unit = await RuleTestHelper.resolveFromFile(_trySwitchPath);
      final issues = UseSetStateSynchronouslyRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [9, 11, 33, 39],
        startColumns: [7, 5, 9, 5],
        locationTexts: [
          'setState',
          'setState',
          'setState',
          'setState',
        ],
        messages: [
          "Avoid calling 'setState' past an await point without checking if the widget is mounted.",
          "Avoid calling 'setState' past an await point without checking if the widget is mounted.",
          "Avoid calling 'setState' past an await point without checking if the widget is mounted.",
          "Avoid calling 'setState' past an await point without checking if the widget is mounted.",
        ],
      );
    });

    test('reports issues with assert statements', () async {
      final unit = await RuleTestHelper.resolveFromFile(_assertExample);
      final issues = UseSetStateSynchronouslyRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [7, 19, 22, 28, 36],
        startColumns: [9, 10, 7, 5, 5],
        locationTexts: [
          'setState',
          'setState',
          'setState',
          'setState',
          'setState',
        ],
        messages: [
          "Avoid calling 'setState' past an await point without checking if the widget is mounted.",
          "Avoid calling 'setState' past an await point without checking if the widget is mounted.",
          "Avoid calling 'setState' past an await point without checking if the widget is mounted.",
          "Avoid calling 'setState' past an await point without checking if the widget is mounted.",
          "Avoid calling 'setState' past an await point without checking if the widget is mounted.",
        ],
      );
    });

    test('reports no issues for context.mounted', () async {
      final unit = await RuleTestHelper.resolveFromFile(_contextMountedPath);
      final issues = UseSetStateSynchronouslyRule().check(unit);

      RuleTestHelper.verifyNoIssues(issues);
    });
  });
}
