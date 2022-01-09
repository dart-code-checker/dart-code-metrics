import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/avoid_unrelated_type_assertions/avoid_unrelated_type_assertions_rule.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _examplePath = 'avoid_unrelated_type_assertions/examples/example.dart';

void main() {
  group('AvoidUnrelatedTypeAssertionsRule', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = AvoidUnrelatedTypeAssertionsRule().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'avoid-unrelated-type-assertions',
        severity: Severity.warning,
      );
    });

    test('reports about found issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = AvoidUnrelatedTypeAssertionsRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [8, 9, 12, 26, 29, 30, 33, 50, 77, 78, 87],
        startColumns: [20, 21, 21, 20, 20, 20, 20, 20, 18, 18, 18],
        locationTexts: [
          'regularString is int',
          'nullableString is int?',
          'regularString is bool',
          'animal is NotAnimal',
          'cat is NotAnimal',
          'cat is NotCat',
          'dog is NotAnimal',
          'myList is List<String>',
          'nonNullableCat is NotCat',
          'nonNullableCat is NotCat?',
          'cat is Dog',
        ],
        messages: [
          'Avoid unrelated "is" assertion. The result is always "false".',
          'Avoid unrelated "is" assertion. The result is always "false".',
          'Avoid unrelated "is" assertion. The result is always "false".',
          'Avoid unrelated "is" assertion. The result is always "false".',
          'Avoid unrelated "is" assertion. The result is always "false".',
          'Avoid unrelated "is" assertion. The result is always "false".',
          'Avoid unrelated "is" assertion. The result is always "false".',
          'Avoid unrelated "is" assertion. The result is always "false".',
          'Avoid unrelated "is" assertion. The result is always "false".',
          'Avoid unrelated "is" assertion. The result is always "false".',
          'Avoid unrelated "is" assertion. The result is always "false".',
        ],
      );
    });
  });
}
