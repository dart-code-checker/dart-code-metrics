@TestOn('vm')
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/prefer_single_widget_per_file/prefer_single_widget_per_file.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _correctExamplePath =
    'prefer_single_widget_per_file/examples/correct_example.dart';
const _incorrectExamplePath =
    'prefer_single_widget_per_file/examples/incorrect_example.dart';

void main() {
  group('PreferSingleWidgetPerFileRule', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_correctExamplePath);
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
        startOffsets: [151, 275, 400],
        startLines: [11, 19, 27],
        startColumns: [1, 1, 1],
        endOffsets: [265, 390, 535],
        messages: [
          'A maximum of widget per file is allowed.',
          'A maximum of widget per file is allowed.',
          'A maximum of widget per file is allowed.',
        ],
      );
    });

    test('with default config reports no issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_correctExamplePath);
      final issues = PreferSingleWidgetPerFileRule().check(unit);

      RuleTestHelper.verifyNoIssues(issues);
    });
  });
}
