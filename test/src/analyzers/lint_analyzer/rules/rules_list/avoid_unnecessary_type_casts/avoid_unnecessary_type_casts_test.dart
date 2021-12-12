import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/avoid_unnecessary_type_casts/avoid_unnecessary_type_casts_rule.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _path = 'avoid_unnecessary_type_casts/examples/example.dart';

void main() {
  group('AvoidUnnecessaryTypeCastsRule', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_path);
      final issues = AvoidUnnecessaryTypeCastsRule().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'avoid-unnecessary-type-casts',
        severity: Severity.warning,
      );
    });

    test('reports about found all issues in example.dart', () async {
      final unit = await RuleTestHelper.resolveFromFile(_path);
      final issues = AvoidUnnecessaryTypeCastsRule().check(unit);

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
          32,
          40,
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
          16,
          20,
        ],
        locationTexts: [
          'regularString as String',
          'nullableString as String?',
          'regularString as String?',
          'animal as Animal',
          'cat as HomeAnimal',
          'cat as Animal',
          'dog as HomeAnimal',
          'dog as Animal',
          'regular as String?',
          'myList as List<int>',
        ],
        messages: [
          'Avoid unnecessary "as" type cast.',
          'Avoid unnecessary "as" type cast.',
          'Avoid unnecessary "as" type cast.',
          'Avoid unnecessary "as" type cast.',
          'Avoid unnecessary "as" type cast.',
          'Avoid unnecessary "as" type cast.',
          'Avoid unnecessary "as" type cast.',
          'Avoid unnecessary "as" type cast.',
          'Avoid unnecessary "as" type cast.',
          'Avoid unnecessary "as" type cast.',
        ],
      );
    });
  });
}
