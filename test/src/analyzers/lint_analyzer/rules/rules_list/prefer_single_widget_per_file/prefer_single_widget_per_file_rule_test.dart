import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/prefer_single_widget_per_file/prefer_single_widget_per_file_rule.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _correctStatefullWidgetExamplePath =
    'prefer_single_widget_per_file/examples/correct_statefull_widget_example.dart';
const _correctStatelessWidgetExamplePath =
    'prefer_single_widget_per_file/examples/correct_stateless_widget_example.dart';
const _incorrectExamplePath =
    'prefer_single_widget_per_file/examples/incorrect_example.dart';
const _multiWidgetsExamplePath =
    'prefer_single_widget_per_file/examples/multi_widgets_example.dart';

void main() {
  group('PreferSingleWidgetPerFileRule', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(
        _correctStatefullWidgetExamplePath,
      );
      final issues = PreferSingleWidgetPerFileRule().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'prefer-single-widget-per-file',
        severity: Severity.style,
      );
    });

    test('with default config reports about found issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_incorrectExamplePath);
      final issues = PreferSingleWidgetPerFileRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [11, 19, 27],
        startColumns: [1, 1, 1],
        messages: [
          'Only a single widget per file is allowed.',
          'Only a single widget per file is allowed.',
          'Only a single widget per file is allowed.',
        ],
      );
    });

    group('with default config reports no issues for', () {
      test('single statefull widget', () async {
        final statefullWidgetUnit = await RuleTestHelper.resolveFromFile(
          _correctStatefullWidgetExamplePath,
        );
        final issues =
            PreferSingleWidgetPerFileRule().check(statefullWidgetUnit);

        RuleTestHelper.verifyNoIssues(issues);
      });
      test('single stateless widget', () async {
        final statelessWidgetUnit = await RuleTestHelper.resolveFromFile(
          _correctStatelessWidgetExamplePath,
        );
        final issues =
            PreferSingleWidgetPerFileRule().check(statelessWidgetUnit);

        RuleTestHelper.verifyNoIssues(issues);
      });
    });

    group('analyze multi widget file', () {
      test('with default config', () async {
        final multiWidgetsUnit = await RuleTestHelper.resolveFromFile(
          _multiWidgetsExamplePath,
        );
        final issues = PreferSingleWidgetPerFileRule().check(multiWidgetsUnit);

        RuleTestHelper.verifyIssues(
          issues: issues,
          startLines: [10, 17],
          startColumns: [1, 1],
          messages: [
            'Only a single widget per file is allowed.',
            'Only a single widget per file is allowed.',
          ],
        );
      });

      test('with custom config', () async {
        final multiWidgetsUnit = await RuleTestHelper.resolveFromFile(
          _multiWidgetsExamplePath,
        );
        final issues =
            PreferSingleWidgetPerFileRule({'ignore-private-widgets': true})
                .check(multiWidgetsUnit);

        RuleTestHelper.verifyNoIssues(issues);
      });
    });
  });
}
