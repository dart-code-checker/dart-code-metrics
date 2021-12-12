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
        startOffsets: [
          120,
          170,
          314,
          612,
          661,
          781,
          826,
          940,
          985,
          1027,
          1069,
          1115,
          1161,
          1285,
          1808,
          1859,
          2065,
          2203,
        ],
        startLines: [
          6,
          7,
          10,
          23,
          24,
          27,
          28,
          31,
          32,
          33,
          34,
          35,
          36,
          44,
          69,
          70,
          79,
          83,
        ],
        startColumns: [
          20,
          21,
          21,
          20,
          20,
          20,
          20,
          20,
          20,
          20,
          20,
          20,
          20,
          20,
          18,
          18,
          18,
          18,
        ],
        endOffsets: [
          140,
          192,
          335,
          632,
          680,
          797,
          839,
          956,
          998,
          1040,
          1086,
          1132,
          1182,
          1307,
          1832,
          1884,
          2075,
          2221,
        ],
        locationTexts: [
          'regularString is int',
          'nullableString is int?',
          'regularString is bool',
          'animal is HomeAnimal',
          'animal is NotAnimal',
          'cat is NotAnimal',
          'cat is NotCat',
          'dog is NotAnimal',
          'animal is Dog',
          'animal is Cat',
          'homeAnimal is Cat',
          'homeAnimal is Dog',
          'homeAnimal is dynamic',
          'myList is List<String>',
          'nonNullableCat is NotCat',
          'nonNullableCat is NotCat?',
          'cat is Dog',
          'homeAnimal is Dog?',
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
