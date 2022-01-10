import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/prefer_match_file_name/prefer_match_file_name_rule.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _examplePath = 'prefer_match_file_name/examples';
const _withSingleClass = '$_examplePath/example.dart';
const _withStateFullWidget = '$_examplePath/example_with_state.dart';
const _withIssue = '$_examplePath/example_with_issue.dart';
const _emptyFile = '$_examplePath/empty_file.dart';
const _privateClass = '$_examplePath/private_class.dart';
const _multiClass = '$_examplePath/multiple_classes_example.dart';
const _multipleEnums = '$_examplePath/multiple_enums.dart';
const _multipleExtensions = '$_examplePath/multiple_extensions.dart';
const _multipleMixins = '$_examplePath/multiple_mixins.dart';
const _codegenFile = '$_examplePath/some_widget.codegen.dart';

void main() {
  group('PreferMatchFileNameRule', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_withSingleClass);
      final issues = PreferMatchFileNameRule().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'prefer-match-file-name',
        severity: Severity.style,
      );
    });

    test('reports no issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_withSingleClass);
      final issues = PreferMatchFileNameRule().check(unit);

      RuleTestHelper.verifyNoIssues(issues);
    });

    test('reports about found issues for incorrect class name', () async {
      final unit = await RuleTestHelper.resolveFromFile(_withIssue);
      final issues = PreferMatchFileNameRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [1],
        startColumns: [7],
        messages: ['File name does not match with first class name.'],
        locationTexts: ['Example'],
      );
    });

    test('reports no issues for statefull widget class', () async {
      final unit = await RuleTestHelper.resolveFromFile(_withStateFullWidget);
      final issues = PreferMatchFileNameRule().check(unit);

      RuleTestHelper.verifyNoIssues(issues);
    });

    test('reports no issues for empty file', () async {
      final unit = await RuleTestHelper.resolveFromFile(_emptyFile);
      final issues = PreferMatchFileNameRule().check(unit);

      RuleTestHelper.verifyNoIssues(issues);
    });

    test('reports no issues for file with only private class', () async {
      final unit = await RuleTestHelper.resolveFromFile(_privateClass);
      final issues = PreferMatchFileNameRule().check(unit);

      RuleTestHelper.verifyNoIssues(issues);
    });

    test('reports no issues for file multiples file', () async {
      final unit = await RuleTestHelper.resolveFromFile(_multiClass);
      final issues = PreferMatchFileNameRule().check(unit);

      RuleTestHelper.verifyNoIssues(issues);
    });

    test(
      'reports about found issue about incorrect file name with enums',
      () async {
        final unit = await RuleTestHelper.resolveFromFile(_multipleEnums);
        final issues = PreferMatchFileNameRule().check(unit);

        RuleTestHelper.verifyIssues(
          issues: issues,
          startLines: [3],
          startColumns: [6],
          messages: ['File name does not match with first enum name.'],
          locationTexts: ['MultipleEnumExample'],
        );
      },
    );

    test(
      'reports about found issue about incorrect file name with extensions',
      () async {
        final unit = await RuleTestHelper.resolveFromFile(_multipleExtensions);
        final issues = PreferMatchFileNameRule().check(unit);

        RuleTestHelper.verifyIssues(
          issues: issues,
          startLines: [3],
          startColumns: [11],
          messages: ['File name does not match with first extension name.'],
          locationTexts: ['MultipleExtensionExample'],
        );
      },
    );

    test(
      'reports about found issue about incorrect file name with mixins',
      () async {
        final unit = await RuleTestHelper.resolveFromFile(_multipleMixins);
        final issues = PreferMatchFileNameRule().check(unit);

        RuleTestHelper.verifyIssues(
          issues: issues,
          startLines: [3],
          startColumns: [7],
          messages: ['File name does not match with first mixin name.'],
          locationTexts: ['MultipleMixinExample'],
        );
      },
    );

    test('reports no issues for codegen file', () async {
      final unit = await RuleTestHelper.resolveFromFile(_codegenFile);
      final issues = PreferMatchFileNameRule().check(unit);

      RuleTestHelper.verifyNoIssues(issues);
    });
  });
}
