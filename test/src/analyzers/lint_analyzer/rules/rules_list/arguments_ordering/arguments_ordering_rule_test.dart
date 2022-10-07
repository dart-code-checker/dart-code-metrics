import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/arguments_ordering/arguments_ordering_rule.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _classExamplePath = 'arguments_ordering/examples/class_example.dart';
const _functionExamplePath =
    'arguments_ordering/examples/function_example.dart';
const _widgetExamplePath = 'arguments_ordering/examples/widget_example.dart';
const _widgetExampleChildLastPath =
    'arguments_ordering/examples/widget_example_child_last.dart';
const _mixedExamplePath = 'arguments_ordering/examples/mixed_example.dart';

void main() {
  group('ArgumentsOrderingRule', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_classExamplePath);
      final issues = ArgumentsOrderingRule().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'arguments-ordering',
        severity: Severity.style,
      );
    });

    test('reports issues with class constructor arguments', () async {
      final unit = await RuleTestHelper.resolveFromFile(_classExamplePath);
      final issues = ArgumentsOrderingRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [16, 17, 18, 19, 20, 21],
        startColumns: [26, 26, 26, 26, 26, 26],
        locationTexts: [
          "(name: 42, surname: '', age: '')",
          "(surname: '', name: '', age: 42)",
          "(surname: '', age: 42, name: '')",
          "(age: 42, surname: '', name: '')",
          "(age: 42, name: '', surname: '')",
          "(age: 42, name: '')",
        ],
        replacements: [
          "(name: 42, age: '', surname: '')",
          "(name: '', age: 42, surname: '')",
          "(name: '', age: 42, surname: '')",
          "(name: '', age: 42, surname: '')",
          "(name: '', age: 42, surname: '')",
          "(name: '', age: 42)",
        ],
      );
    });

    test('reports issues with function arguments', () async {
      final unit = await RuleTestHelper.resolveFromFile(_functionExamplePath);
      final issues = ArgumentsOrderingRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [8, 9, 10, 11, 12, 13],
        startColumns: [32, 32, 32, 32, 32, 32],
        locationTexts: [
          "(name: 42, surname: '', age: '')",
          "(surname: '', name: '', age: 42)",
          "(surname: '', age: 42, name: '')",
          "(age: 42, surname: '', name: '')",
          "(age: 42, name: '', surname: '')",
          "(age: 42, name: '')",
        ],
        replacements: [
          "(name: 42, age: '', surname: '')",
          "(name: '', age: 42, surname: '')",
          "(name: '', age: 42, surname: '')",
          "(name: '', age: 42, surname: '')",
          "(name: '', age: 42, surname: '')",
          "(name: '', age: 42)",
        ],
      );
    });

    test('reports issues with Flutter widget arguments', () async {
      final unit = await RuleTestHelper.resolveFromFile(_widgetExamplePath);
      final issues = ArgumentsOrderingRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [17, 18, 19, 20, 21],
        startColumns: [32, 32, 32, 32, 32],
        locationTexts: [
          "(name: '', age: 42, child: Container())",
          "(child: Container(), name: '', age: 42)",
          "(child: Container(), age: 42, name: '')",
          "(age: 42, child: Container(), name: '')",
          "(age: 42, name: '', child: Container())",
        ],
        replacements: [
          "(name: '', child: Container(), age: 42)",
          "(name: '', child: Container(), age: 42)",
          "(name: '', child: Container(), age: 42)",
          "(name: '', child: Container(), age: 42)",
          "(name: '', child: Container(), age: 42)",
        ],
      );
    });

    test(
      'reports issues with Flutter widget arguments and "childLast" config option',
      () async {
        final unit =
            await RuleTestHelper.resolveFromFile(_widgetExampleChildLastPath);
        final issues = ArgumentsOrderingRule({'child-last': true}).check(unit);

        RuleTestHelper.verifyIssues(
          issues: issues,
          startLines: [15, 18, 20, 22, 24, 26],
          startColumns: [32, 17, 17, 17, 17, 17],
          locationTexts: [
            "(name: '', child: Container(), children: [])",
            "(name: '', child: Container(), children: [])",
            "(child: Container(), children: [], name: '')",
            "(child: Container(), name: '', children: [])",
            "(children: [], child: Container(), name: '')",
            "(children: [], name: '', child: Container())",
          ],
          replacements: [
            "(name: '', children: [], child: Container())",
            "(name: '', children: [], child: Container())",
            "(name: '', children: [], child: Container())",
            "(name: '', children: [], child: Container())",
            "(name: '', children: [], child: Container())",
            "(name: '', children: [], child: Container())",
          ],
        );
      },
    );

    test('reports issues with mixed (named + unnamed) arguments', () async {
      final unit = await RuleTestHelper.resolveFromFile(_mixedExamplePath);
      final issues = ArgumentsOrderingRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [6, 7, 8, 9, 10],
        startColumns: [20, 20, 20, 20, 20],
        locationTexts: [
          "('a', c: 'c', 'b', d: 'd')",
          "('a', d: 'd', 'b', c: 'c')",
          "('a', 'b', d: 'd', c: 'c')",
          "('a', c: 'c', 'b')",
          "(c: 'c', 'a', 'b')",
        ],
        replacements: [
          "('a', 'b', c: 'c', d: 'd')",
          "('a', 'b', c: 'c', d: 'd')",
          "('a', 'b', c: 'c', d: 'd')",
          "('a', 'b', c: 'c')",
          "('a', 'b', c: 'c')",
        ],
      );
    });
  });
}
