import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/avoid_unnecessary_type_assertions/avoid_unnecessary_type_assertions_rule.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _path = 'avoid_unnecessary_type_assertions/examples';
const _classExampleWithIs = '$_path/example_with_is.dart';
const _classExampleCases = '$_path/example_cases.dart';

void main() {
  group('AvoidUnnecessaryTypeAssertionsRule', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_classExampleWithIs);
      final issues = AvoidUnnecessaryTypeAssertionsRule().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'avoid-unnecessary-type-assertions',
        severity: Severity.style,
      );
    });

    test('reports about found all issues in example_with_is.dart', () async {
      final unit = await RuleTestHelper.resolveFromFile(_classExampleWithIs);
      final issues = AvoidUnnecessaryTypeAssertionsRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startOffsets: [
          120,
          173,
          228,
          539,
          584,
          630,
          672,
          718,
          1020,
          1372,
          1420,
          1506,
          1553,
          1620,
          1744,
          1954,
          2021,
          2099,
          2204,
          2263,
        ],
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
          79,
          82,
          84,
          85,
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
          18,
          18,
          18,
          18,
        ],
        endOffsets: [
          143,
          198,
          252,
          555,
          601,
          643,
          689,
          731,
          1039,
          1393,
          1442,
          1525,
          1585,
          1653,
          1774,
          1965,
          2034,
          2121,
          2228,
          2291,
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
          'cat is Animal',
          'dogs.whereType<Dog?>()',
          'dogs.whereType<Animal>()',
          'animals.whereType<Animal?>()',
        ],
        messages: [
          'Avoid unnecessary "is" assertion.',
          'Avoid unnecessary "is" assertion.',
          'Avoid unnecessary "is" assertion.',
          'Avoid unnecessary "is" assertion.',
          'Avoid unnecessary "is" assertion.',
          'Avoid unnecessary "is" assertion.',
          'Avoid unnecessary "is" assertion.',
          'Avoid unnecessary "is" assertion.',
          'Avoid unnecessary "is" assertion.',
          'Avoid unnecessary "is" assertion.',
          'Avoid unnecessary "is" assertion.',
          'Avoid unnecessary "is" assertion.',
          'Avoid unnecessary "whereType" assertion.',
          'Avoid unnecessary "whereType" assertion.',
          'Avoid unnecessary "whereType" assertion.',
          'Avoid unnecessary "is" assertion.',
          'Avoid unnecessary "is" assertion.',
          'Avoid unnecessary "whereType" assertion.',
          'Avoid unnecessary "whereType" assertion.',
          'Avoid unnecessary "whereType" assertion.',
        ],
      );
    });

    test('reports about found all issues in example_cases.dart', () async {
      final unit = await RuleTestHelper.resolveFromFile(_classExampleCases);
      final issues = AvoidUnnecessaryTypeAssertionsRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startOffsets: [118, 290, 497, 572, 647, 832, 946, 1030, 1060],
        startLines: [6, 12, 21, 24, 27, 38, 44, 49, 50],
        startColumns: [3, 3, 3, 3, 3, 14, 14, 3, 3],
        endOffsets: [149, 313, 519, 593, 669, 838, 964, 1049, 1082],
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
          'Avoid unnecessary "whereType" assertion.',
          'Avoid unnecessary "whereType" assertion.',
          'Avoid unnecessary "whereType" assertion.',
          'Avoid unnecessary "whereType" assertion.',
          'Avoid unnecessary "whereType" assertion.',
          'Avoid unnecessary "is" assertion.',
          'Avoid unnecessary "is" assertion.',
          'Avoid unnecessary "is" assertion.',
          'Avoid unnecessary "is" assertion.',
        ],
      );
    });
  });
}
