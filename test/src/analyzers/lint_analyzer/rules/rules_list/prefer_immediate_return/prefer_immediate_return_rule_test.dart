import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/prefer_immediate_return/prefer_immediate_return_rule.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _examplePath = 'prefer_immediate_return/examples/example.dart';

void main() {
  group(
    'PreferImmediateReturnRule',
    () {
      test('initialization', () async {
        final unit = await RuleTestHelper.resolveFromFile(_examplePath);
        final issues = PreferImmediateReturnRule().check(unit);

        RuleTestHelper.verifyInitialization(
          issues: issues,
          ruleId: 'prefer-immediate-return',
          severity: Severity.style,
        );
      });

      test('reports about found issues', () async {
        final unit = await RuleTestHelper.resolveFromFile(_examplePath);
        final issues = PreferImmediateReturnRule().check(unit);

        RuleTestHelper.verifyIssues(
          issues: issues,
          startLines: [
            2,
            10,
            16,
            21,
            28,
            47,
            51,
            61,
            66,
          ],
          startColumns: [
            3,
            3,
            3,
            5,
            3,
            5,
            5,
            5,
            5,
          ],
          messages: [
            'Prefer returning the result immediately instead of declaring an intermediate variable right before the return statement.',
            'Prefer returning the result immediately instead of declaring an intermediate variable right before the return statement.',
            'Prefer returning the result immediately instead of declaring an intermediate variable right before the return statement.',
            'Prefer returning the result immediately instead of declaring an intermediate variable right before the return statement.',
            'Prefer returning the result immediately instead of declaring an intermediate variable right before the return statement.',
            'Prefer returning the result immediately instead of declaring an intermediate variable right before the return statement.',
            'Prefer returning the result immediately instead of declaring an intermediate variable right before the return statement.',
            'Prefer returning the result immediately instead of declaring an intermediate variable right before the return statement.',
            'Prefer returning the result immediately instead of declaring an intermediate variable right before the return statement.',
          ],
          replacementComments: [
            'Replace with immediate return.',
            'Replace with immediate return.',
            'Replace with immediate return.',
            'Replace with immediate return.',
            'Replace with immediate return.',
            'Replace with immediate return.',
            'Replace with immediate return.',
            'Replace with immediate return.',
            'Replace with immediate return.',
          ],
          replacements: [
            'return a + b;',
            'return a + b;',
            'return a + b;',
            'return width * height;',
            'return null;',
            'return a + b;',
            'return 0;',
            'return a * b;',
            'return a + b;',
          ],
          locationTexts: [
            'final sum = a + b;\n'
                '\n'
                '  return sum;',
            'return sum;',
            'return sum;',
            'final result = width * height;\n'
                '\n'
                '    return result;',
            'final String? x;\n'
                '\n'
                '  return x;',
            'final sum = a + b;\n'
                '\n'
                '    return sum;',
            'final sum = 0;\n'
                '\n'
                '    return sum;',
            'final result = a * b;\n'
                '\n'
                '    return result;',
            'final result = a + b;\n'
                '\n'
                '    return result;',
          ],
        );
      });
    },
  );
}
