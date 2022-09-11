import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/avoid_unnecessary_type_assertions/avoid_unnecessary_type_assertions_rule.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _path = 'avoid_unnecessary_type_assertions/examples';
const _classExampleWithIs = '$_path/example_with_is.dart';
const _classExampleCases = '$_path/example_cases.dart';
const _notIsExamplePath = '$_path/example_with_not_is.dart';

void main() {
  group('AvoidUnnecessaryTypeAssertionsRule', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_classExampleWithIs);
      final issues = AvoidUnnecessaryTypeAssertionsRule().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'avoid-unnecessary-type-assertions',
        severity: Severity.warning,
      );
    });

    test('reports about all found issues in example_with_is.dart', () async {
      final unit = await RuleTestHelper.resolveFromFile(_classExampleWithIs);
      final issues = AvoidUnnecessaryTypeAssertionsRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [
          6,
          7,
          8,
          21,
          22,
          23,
          24,
          25,
          38,
          59,
          60,
          62,
          64,
          65,
          67,
          77,
          78,
          80,
          81,
          82,
          86,
          88,
          89,
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
          18,
          18,
          18,
          18,
          18,
          18,
          18,
          21,
          21,
          18,
          21,
          18,
          18,
          18,
        ],
        locationTexts: [
          'regularString is String',
          'nullableString is String?',
          'regularString is String?',
          'animal is Animal',
          'cat is HomeAnimal',
          'cat is Animal',
          'dog is HomeAnimal',
          'dog is Animal',
          'myList is List<int>',
          'nonNullableCat is Cat',
          'nonNullableCat is Cat?',
          'nullableCat is Cat?',
          'nonNullableCats.whereType<Cat>()',
          'nonNullableCats.whereType<Cat?>()',
          'nullableCats.whereType<Cat?>()',
          'cat is Cat?',
          'cat is! Cat?',
          'cat is! Dog',
          'cat is Animal',
          'cat is! Animal',
          'dogs.whereType<Dog?>()',
          'dogs.whereType<Animal>()',
          'animals.whereType<Animal?>()',
        ],
        messages: [
          'Avoid unnecessary "is" assertion. The result is always "true".',
          'Avoid unnecessary "is" assertion. The result is always "true".',
          'Avoid unnecessary "is" assertion. The result is always "true".',
          'Avoid unnecessary "is" assertion. The result is always "true".',
          'Avoid unnecessary "is" assertion. The result is always "true".',
          'Avoid unnecessary "is" assertion. The result is always "true".',
          'Avoid unnecessary "is" assertion. The result is always "true".',
          'Avoid unnecessary "is" assertion. The result is always "true".',
          'Avoid unnecessary "is" assertion. The result is always "true".',
          'Avoid unnecessary "is" assertion. The result is always "true".',
          'Avoid unnecessary "is" assertion. The result is always "true".',
          'Avoid unnecessary "is" assertion. The result is always "true".',
          'Avoid unnecessary "whereType<Cat>()" assertion.',
          'Avoid unnecessary "whereType<Cat?>()" assertion.',
          'Avoid unnecessary "whereType<Cat?>()" assertion.',
          'Avoid unnecessary "is" assertion. The result is always "true".',
          'Avoid unnecessary "is!" assertion. The result is always "false".',
          'Avoid unnecessary "is!" assertion. The result is always "false".',
          'Avoid unnecessary "is" assertion. The result is always "true".',
          'Avoid unnecessary "is!" assertion. The result is always "false".',
          'Avoid unnecessary "whereType<Dog?>()" assertion.',
          'Avoid unnecessary "whereType<Animal>()" assertion.',
          'Avoid unnecessary "whereType<Animal?>()" assertion.',
        ],
      );
    });

    test(
      'reports about all found issues in example_with_not_is.dart',
      () async {
        final unit = await RuleTestHelper.resolveFromFile(_notIsExamplePath);
        final issues = AvoidUnnecessaryTypeAssertionsRule().check(unit);

        RuleTestHelper.verifyIssues(
          issues: issues,
          startLines: [14, 16, 17],
          startColumns: [17, 17, 17],
          locationTexts: [
            'cat is! Cat',
            'cat is! Dog',
            'cat is! NotAnimal',
          ],
          messages: [
            'Avoid unnecessary "is!" assertion. The result is always "false".',
            'Avoid unnecessary "is!" assertion. The result is always "false".',
            'Avoid unnecessary "is!" assertion. The result is always "false".',
          ],
        );
      },
    );

    test('reports about all found issues in example_cases.dart', () async {
      final unit = await RuleTestHelper.resolveFromFile(_classExampleCases);
      final issues = AvoidUnnecessaryTypeAssertionsRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [6, 12, 21, 24, 27, 38, 44, 49, 50],
        startColumns: [3, 3, 3, 3, 3, 14, 14, 3, 3],
        locationTexts: [
          "['1', '2'].whereType<String?>()",
          '[1, 2].whereType<int>()',
          'a.whereType<String?>()',
          'b.whereType<String>()',
          'b.whereType<String?>()',
          'b is A',
          'regular is String?',
          'myList is List<int>',
          'myList is List<Object>',
        ],
        messages: [
          'Avoid unnecessary "whereType<String?>()" assertion.',
          'Avoid unnecessary "whereType<int>()" assertion.',
          'Avoid unnecessary "whereType<String?>()" assertion.',
          'Avoid unnecessary "whereType<String>()" assertion.',
          'Avoid unnecessary "whereType<String?>()" assertion.',
          'Avoid unnecessary "is" assertion. The result is always "true".',
          'Avoid unnecessary "is" assertion. The result is always "true".',
          'Avoid unnecessary "is" assertion. The result is always "true".',
          'Avoid unnecessary "is" assertion. The result is always "true".',
        ],
      );
    });
  });
}
