import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/use_setstate_synchronously/use_setstate_synchronously_rule.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _examplePath = 'use_setstate_synchronously/examples/example.dart';
const _issuesPath = 'use_setstate_synchronously/examples/known_errors.dart';

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
        startLines: [6, 11, 18, 33, 48, 52, 58, 64, 72],
        startColumns: [10, 7, 7, 5, 7, 5, 5, 5, 9],
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
  });
}
