import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/avoid_collection_methods_with_unrelated_types/avoid_collection_methods_with_unrelated_types_rule.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _examplePath =
    'avoid_collection_methods_with_unrelated_types/examples/example.dart';
const _nullableExamplePath =
    'avoid_collection_methods_with_unrelated_types/examples/nullable_example.dart';
const _dynamicExamplePath =
    'avoid_collection_methods_with_unrelated_types/examples/dynamic_example.dart';

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
        startLines: [
          6,
          9,
          12,
          15,
          18,
          27,
          32,
          35,
          38,
          41,
          48,
          50,
          55,
          58,
          61,
          67,
          74,
          77,
          80,
          83,
          86,
          89,
          92,
          95,
        ],
        startColumns: [
          5,
          16,
          5,
          5,
          5,
          5,
          16,
          5,
          5,
          5,
          14,
          5,
          5,
          5,
          5,
          5,
          5,
          5,
          5,
          5,
          5,
          5,
          5,
          5,
        ],
        locationTexts: [
          'primitiveMap["str"]',
          'primitiveMap["str"]',
          'primitiveMap.containsKey("str")',
          'primitiveMap.containsValue(100)',
          'primitiveMap.remove("str")',
          'inheritanceMap[Flower()]',
          'inheritanceMap[Flower()]',
          'inheritanceMap.containsKey(Flower())',
          'inheritanceMap.containsValue(DogImplementsAnimal())',
          'inheritanceMap.remove(Flower())',
          'myMap["str"]',
          'myMap.containsKey("str")',
          '<int>[1, 2, 3].contains("str")',
          'Iterable<int>.generate(10).contains("str")',
          '<int>{1, 2, 3}.contains("str")',
          'primitiveList.remove("str")',
          'primitiveSet.contains("str")',
          'primitiveSet.containsAll(Iterable<String>.empty())',
          'primitiveSet.difference(<String>{})',
          'primitiveSet.intersection(<String>{})',
          'primitiveSet.lookup("str")',
          'primitiveSet.remove("str")',
          'primitiveSet.removeAll(Iterable<String>.empty())',
          'primitiveSet.retainAll(Iterable<String>.empty())',
        ],
        messages: [
          'Avoid collection methods with unrelated types.',
          'Avoid collection methods with unrelated types.',
          'Avoid collection methods with unrelated types.',
          'Avoid collection methods with unrelated types.',
          'Avoid collection methods with unrelated types.',
          'Avoid collection methods with unrelated types.',
          'Avoid collection methods with unrelated types.',
          'Avoid collection methods with unrelated types.',
          'Avoid collection methods with unrelated types.',
          'Avoid collection methods with unrelated types.',
          'Avoid collection methods with unrelated types.',
          'Avoid collection methods with unrelated types.',
          'Avoid collection methods with unrelated types.',
          'Avoid collection methods with unrelated types.',
          'Avoid collection methods with unrelated types.',
          'Avoid collection methods with unrelated types.',
          'Avoid collection methods with unrelated types.',
          'Avoid collection methods with unrelated types.',
          'Avoid collection methods with unrelated types.',
          'Avoid collection methods with unrelated types.',
          'Avoid collection methods with unrelated types.',
          'Avoid collection methods with unrelated types.',
          'Avoid collection methods with unrelated types.',
          'Avoid collection methods with unrelated types.',
        ],
      );
    });

    test('reports about found issues for nullable collections', () async {
      final unit = await RuleTestHelper.resolveFromFile(_nullableExamplePath);
      final issues = AvoidCollectionMethodsWithUnrelatedTypesRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [4, 10, 15, 20, 25, 30],
        startColumns: [5, 5, 5, 5, 5, 5],
        locationTexts: [
          'regularMap[null]',
          'nullableMap["str"]',
          'regularList.remove(null)',
          'nullableList.remove("str")',
          'regularSet.contains(null)',
          'nullableSet.contains("str")',
        ],
        messages: [
          'Avoid collection methods with unrelated types.',
          'Avoid collection methods with unrelated types.',
          'Avoid collection methods with unrelated types.',
          'Avoid collection methods with unrelated types.',
          'Avoid collection methods with unrelated types.',
          'Avoid collection methods with unrelated types.',
        ],
      );
    });

    test('reports about found issues for dynamic keys', () async {
      final unit = await RuleTestHelper.resolveFromFile(_dynamicExamplePath);
      final issues = AvoidCollectionMethodsWithUnrelatedTypesRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [6, 13],
        startColumns: [5, 5],
        locationTexts: [
          'regularMap[key]',
          'regularMap[key]',
        ],
        messages: [
          'Avoid collection methods with unrelated types.',
          'Avoid collection methods with unrelated types.',
        ],
      );
    });

    test('reports no issues for dynamic keys if not in strict mode', () async {
      final unit = await RuleTestHelper.resolveFromFile(_dynamicExamplePath);
      final issues = AvoidCollectionMethodsWithUnrelatedTypesRule(const {
        'strict': false,
      }).check(unit);

      RuleTestHelper.verifyNoIssues(issues);
    });
  });
}
