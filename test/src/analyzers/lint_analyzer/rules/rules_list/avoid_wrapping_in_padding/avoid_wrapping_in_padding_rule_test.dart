import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/avoid_wrapping_in_padding/avoid_wrapping_in_padding_rule.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _examplePath = 'avoid_wrapping_in_padding/examples/example.dart';

void main() {
  group('AvoidWrappingInPaddingRule', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = AvoidWrappingInPaddingRule().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'avoid-wrapping-in-padding',
        severity: Severity.warning,
      );
    });

    test('reports about found issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = AvoidWrappingInPaddingRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [4],
        startColumns: [12],
        locationTexts: [
          'Padding(\n'
              '      child: Container(),\n'
              '    )',
        ],
        messages: [
          'Avoid wrapping a Container in a Padding widget.',
        ],
      );
    });
  });
}
