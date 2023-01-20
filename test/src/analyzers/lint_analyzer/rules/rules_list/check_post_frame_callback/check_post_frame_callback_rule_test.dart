import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/check_post_frame_callback/check_post_frame_callback_rule.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _examplePath = 'check_post_frame_callback/examples/example.dart';

void main() {
  group('CheckPostFrameCallbackRule', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = CheckPostFrameCallbackRule().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'check-post-frame-callback',
        severity: Severity.error,
      );
    });

    test('reports about found issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = CheckPostFrameCallbackRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [4],
        startColumns: [3],
        locationTexts: [
          'WidgetsBinding.instance.addPostFrameCallback((_) {})',
        ],
        messages: [
          'To be compatiable with flutter2, `addPostFrameCallback` should be called on `WidgetsBinding.instance?`',
        ],
      );
    });
  });
}
