import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/prefer_static_class/prefer_static_class_rule.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _incorrectExamplePath =
    'prefer_static_class/examples/incorrect_example.dart';
const _correctExamplePath = 'prefer_static_class/examples/correct_example.dart';
const _correctIgnorePrivateExamplePath =
    'prefer_static_class/examples/correct_ignore_private_example.dart';
const _correctIgnoreNamesExamplePath =
    'prefer_static_class/examples/correct_ignore_names_example.dart';
const _correctIgnoreAnnotationExamplePath =
    'prefer_static_class/examples/correct_ignore_annotation_example.dart';

void main() {
  group('PreferStaticClassRule', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_incorrectExamplePath);
      final issues = PreferStaticClassRule().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'prefer-static-class',
        severity: Severity.style,
      );
    });

    test('reports issues on incorrect example', () async {
      final unit = await RuleTestHelper.resolveFromFile(_incorrectExamplePath);
      final issues = PreferStaticClassRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [1, 2, 3, 4, 6, 7, 8, 9],
        startColumns: [1, 1, 1, 1, 1, 1, 1, 1],
        locationTexts: [
          'void globalFunction() {}',
          'var globalVariable = 42;',
          'final globalFinalVariable = 42;',
          'const globalConstant = 42;',
          'void _privateGlobalFunction() {}',
          'var _privateGlobalVariable = 42;',
          'final _privateGlobalFinalVariable = 42;',
          'const _privateGlobalConstant = 42;',
        ],
        messages: [
          'Prefer declaring static class members instead of global functions, variables and constants.',
          'Prefer declaring static class members instead of global functions, variables and constants.',
          'Prefer declaring static class members instead of global functions, variables and constants.',
          'Prefer declaring static class members instead of global functions, variables and constants.',
          'Prefer declaring static class members instead of global functions, variables and constants.',
          'Prefer declaring static class members instead of global functions, variables and constants.',
          'Prefer declaring static class members instead of global functions, variables and constants.',
          'Prefer declaring static class members instead of global functions, variables and constants.',
        ],
      );
    });

    test('do not reports any issues on correct example', () async {
      final unit = await RuleTestHelper.resolveFromFile(_correctExamplePath);
      final issues = PreferStaticClassRule().check(unit);

      RuleTestHelper.verifyNoIssues(issues);
    });

    test(
      'do not reports any issues on correct "ignore private" example',
      () async {
        final unit = await RuleTestHelper.resolveFromFile(
          _correctIgnorePrivateExamplePath,
        );
        final issues = PreferStaticClassRule({
          'ignore-private': true,
        }).check(unit);

        RuleTestHelper.verifyNoIssues(issues);
      },
    );

    test(
      'do not reports any issues on correct "ignore names" example',
      () async {
        final unit = await RuleTestHelper.resolveFromFile(
          _correctIgnoreNamesExamplePath,
        );
        final issues = PreferStaticClassRule({
          'ignore-names': [
            '(.*)Provider',
            'use(.*)',
          ],
        }).check(unit);

        RuleTestHelper.verifyNoIssues(issues);
      },
    );

    test(
      'do not reports any issues on correct "ignore annotation" example',
      () async {
        final unit = await RuleTestHelper.resolveFromFile(
          _correctIgnoreAnnotationExamplePath,
        );
        final issues = PreferStaticClassRule({
          'ignore-annotations': [
            'ignoredAnnotation',
          ],
        }).check(unit);

        RuleTestHelper.verifyNoIssues(issues);
      },
    );
  });
}
