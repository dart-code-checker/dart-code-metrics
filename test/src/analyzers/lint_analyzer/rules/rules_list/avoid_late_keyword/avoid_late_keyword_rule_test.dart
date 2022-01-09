import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/avoid_late_keyword/avoid_late_keyword_rule.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _examplePath = 'avoid_late_keyword/examples/example.dart';

void main() {
  group('AvoidLateKeywordRule', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = AvoidLateKeywordRule().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'avoid-late-keyword',
        severity: Severity.warning,
      );
    });

    test('reports about found issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = AvoidLateKeywordRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [2, 8, 11, 17, 21, 23],
        startColumns: [3, 3, 5, 5, 1, 1],
        locationTexts: [
          "late final field = 'string'",
          'late String uninitializedField',
          "late final variable = 'string'",
          'late String uninitializedVariable',
          "late final topLevelVariable = 'string'",
          'late String topLevelUninitializedVariable',
        ],
        messages: [
          "Avoid using 'late' keyword.",
          "Avoid using 'late' keyword.",
          "Avoid using 'late' keyword.",
          "Avoid using 'late' keyword.",
          "Avoid using 'late' keyword.",
          "Avoid using 'late' keyword.",
        ],
      );
    });
  });
}
