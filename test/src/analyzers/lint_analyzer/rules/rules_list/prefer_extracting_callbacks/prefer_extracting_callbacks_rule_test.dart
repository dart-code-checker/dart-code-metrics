import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/prefer_extracting_callbacks/prefer_extracting_callbacks_rule.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _examplePath = 'prefer_extracting_callbacks/examples/example.dart';
const _exampleMaxLineCountPath =
    'prefer_extracting_callbacks/examples/example_max_line_count.dart';

void main() {
  group('PreferExtractingCallbacksRule', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = PreferExtractingCallbacksRule().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'prefer-extracting-callbacks',
        severity: Severity.style,
      );
    });

    test('reports about found issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = PreferExtractingCallbacksRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [11, 55, 97],
        startColumns: [7, 7, 9],
        locationTexts: [
          'onPressed: () {\n'
              '        return null;\n'
              '      }',
          'onPressed: () {\n'
              '        return null;\n'
              '      }',
          'onPressed: () {\n'
              '          return null;\n'
              '        }',
        ],
        messages: [
          'Prefer extracting the callback to a separate widget method.',
          'Prefer extracting the callback to a separate widget method.',
          'Prefer extracting the callback to a separate widget method.',
        ],
      );
    });

    test('with ignored-named-arguments config reports no issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final config = {
        'ignored-named-arguments': [
          'onPressed',
        ],
      };

      final issues = PreferExtractingCallbacksRule(config).check(unit);

      RuleTestHelper.verifyNoIssues(issues);
    });

    test('with allowed-line-count config', () async {
      final unit =
          await RuleTestHelper.resolveFromFile(_exampleMaxLineCountPath);
      final config = {
        'allowed-line-count': 3,
      };

      final issues = PreferExtractingCallbacksRule(config).check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [20],
        startColumns: [7],
        locationTexts: [
          'onPressed: () {\n'
              '        firstLine();\n'
              '        secondLine();\n'
              '        thirdLine();\n'
              '        fourthLine();\n'
              '      }',
        ],
        messages: [
          'Prefer extracting the callback to a separate widget method.',
        ],
      );
    });
  });
}
