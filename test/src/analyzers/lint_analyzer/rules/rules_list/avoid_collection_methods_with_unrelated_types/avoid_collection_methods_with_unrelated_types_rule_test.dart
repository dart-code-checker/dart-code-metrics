import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/avoid_collection_methods_with_unrelated_types/avoid_collection_methods_with_unrelated_types_rule.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _examplePath = 'avoid_collection_methods_with_unrelated_types/examples/example.dart';

void main() {
  group('AvoidCollectionMethodsWithUnrelatedTypesRule', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = AvoidCollectionMethodsWithUnrelatedTypesRule().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'avoid-collection-methods-with-unrelated-types',
        severity: Severity.warning,
      );
    });

    test('reports about found issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = AvoidCollectionMethodsWithUnrelatedTypesRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [5, 8, 15, 20],
        startColumns: [3, 14, 3, 14],
        locationTexts: [
          'primitiveMap["str"]',
          'primitiveMap["str"]',
          'inheritanceMap[Flower()]',
          'inheritanceMap[Flower()]',
        ],
        messages: [
          'Avoid collection methods with unrelated types.',
          'Avoid collection methods with unrelated types.',
          'Avoid collection methods with unrelated types.',
          'Avoid collection methods with unrelated types.',
        ],
      );
    });
  });
}
