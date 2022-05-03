import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/avoid_non_ascii_symbols/avoid_non_ascii_symbols_rule.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _examplePath = 'avoid_non_ascii_symbols/examples/example.dart';

void main() {
  group('AvoidNonAsciiSymbolsRule', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = AvoidNonAsciiSymbolsRule().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'avoid-non-ascii-symbols',
        severity: Severity.warning,
      );
    });

    test('reports about found issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = AvoidNonAsciiSymbolsRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [3, 4, 6, 7],
        startColumns: [19, 19, 27, 23],
        locationTexts: [
          "'hello 汉字'",
          "'hello привет'",
          r"'#!$_&-  éè  ;∞¥₤€'",
          "'inform@tiv€'",
        ],
        messages: [
          'Avoid using non ascii symbols in string literals.',
          'Avoid using non ascii symbols in string literals.',
          'Avoid using non ascii symbols in string literals.',
          'Avoid using non ascii symbols in string literals.',
        ],
      );
    });
  });
}
