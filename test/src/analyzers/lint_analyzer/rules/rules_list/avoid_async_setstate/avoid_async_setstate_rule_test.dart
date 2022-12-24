import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/avoid_async_setstate/avoid_async_setstate_rule.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _examplePath = 'avoid_async_setstate/examples/example.dart';

void main() {
  group('AvoidAsyncSetStateRule', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = AvoidAsyncSetStateRule().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'avoid-async-setstate',
        severity: Severity.warning,
      );
    });

    test('reports about found issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = AvoidAsyncSetStateRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [6, 11, 18, 33, 41],
        startColumns: [10, 7, 7, 5, 9],
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
  });
}
