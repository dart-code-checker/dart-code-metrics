import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/avoid_creating_vector_in_update/avoid_creating_vector_in_update_rule.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _examplePath = 'avoid_creating_vector_in_update/examples/example.dart';

void main() {
  group('AvoidCreatingVectorInUpdateRule', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = AvoidCreatingVectorInUpdateRule().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'avoid-creating-vector-in-update',
        severity: Severity.warning,
      );
    });

    test('reports about found issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = AvoidCreatingVectorInUpdateRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [4, 23, 24],
        startColumns: [23, 23, 23],
        locationTexts: [
          'Vector2(10, 10)',
          'vector1 + vector2',
          'vector1 - vector2',
        ],
        messages: [
          "Avoid creating Vector2 in 'update' method.",
          "Avoid creating Vector2 in 'update' method.",
          "Avoid creating Vector2 in 'update' method.",
        ],
      );
    });
  });
}
