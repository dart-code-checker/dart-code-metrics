import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/avoid_unnecessary_type_assertions/avoid_unnecessary_type_assertions.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _path = 'avoid_unnecessary_type_assertions/examples';
const _classExampleWithIs = '$_path/example_with_is.dart';
const _classExampleCases = '$_path/example_cases.dart';

void main() {
  group('AvoidUnnecessaryTypeAssertions', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_classExampleWithIs);
      final issues = AvoidUnnecessaryTypeAssertions().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'avoid-unnecessary-type-assertions',
        severity: Severity.style,
      );
    });

    test('reports about found all issues in example_with_is.dart', () async {
      final unit = await RuleTestHelper.resolveFromFile(_classExampleWithIs);
      final issues = AvoidUnnecessaryTypeAssertions().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startOffsets: [
          120,
          228,
          539,
          584,
          630,
          672,
          718,
          1020,
          1053,
        ],
        startLines: [
          6,
          8,
          21,
          22,
          23,
          24,
          25,
          38,
          39,
        ],
        startColumns: [
          20,
          21,
          20,
          20,
          20,
          20,
          20,
          20,
          5,
        ],
        endOffsets: [
          143,
          252,
          555,
          601,
          643,
          689,
          731,
          1039,
          1076,
        ],
        locationTexts: [
          'regularString is String',
          'regularString is String?',
          'animal is Animal',
          'cat is HomeAnimal',
          'cat is Animal',
          'dog is HomeAnimal',
          'dog is Animal',
          'myList is List<int>',
          'myList.whereType<int>()',
        ],
        messages: [
          'Avoid redundant "is" assertion.',
          'Avoid redundant "is" assertion.',
          'Avoid redundant "is" assertion.',
          'Avoid redundant "is" assertion.',
          'Avoid redundant "is" assertion.',
          'Avoid redundant "is" assertion.',
          'Avoid redundant "is" assertion.',
          'Avoid redundant "is" assertion.',
          'Avoid redundant "whereType" assertion.',
        ],
      );
    });

    test('reports about found all issues in example_cases.dart', () async {
      final unit = await RuleTestHelper.resolveFromFile(_classExampleCases);
      final issues = AvoidUnnecessaryTypeAssertions().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startOffsets: [121, 235, 279, 454, 486, 514, 566],
        startLines: [10, 16, 19, 26, 27, 28, 29],
        startColumns: [14, 14,  5, 5, 5, 5, 21],
        endOffsets: [127, 253, 310, 473, 508, 537, 578],
        locationTexts: [
          'b is A',
          'regular is String?',
          "['1', '2'].whereType<String?>()",
          'myList is List<int>',
          'myList is List<Object>',
          'myList.whereType<int>()',
          'a is dynamic',
        ],
        messages: [
          'Avoid redundant "is" assertion.',
          'Avoid redundant "is" assertion.',
          'Avoid redundant "whereType" assertion.',
          'Avoid redundant "is" assertion.',
          'Avoid redundant "is" assertion.',
          'Avoid redundant "whereType" assertion.',
          'Avoid redundant "is" assertion.',
        ],
      );
    });
  });
}
