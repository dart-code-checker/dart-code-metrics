@TestOn('vm')
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/prefer_conditional_expressions/prefer_conditional_expressions.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _examplePath = 'prefer_conditional_expressions/examples/example.dart';

void main() {
  group('PreferConditionalExpressionsRule', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = PreferConditionalExpressionsRule().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'prefer-conditional-expressions',
        severity: Severity.style,
      );
    });

    test('reports about found issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = PreferConditionalExpressionsRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startOffsets: [111, 289, 426, 490, 557, 616, 889, 1040],
        startLines: [11, 30, 45, 51, 58, 64, 93, 109],
        startColumns: [3, 3, 3, 3, 3, 3, 3, 3],
        endOffsets: [161, 345, 476, 543, 602, 663, 930, 1087],
        locationTexts: [
          'if (a == 3) {\n'
              '    a = 2;\n'
              '  } else {\n'
              '    a = 3;\n'
              '  }',
          'if (a == 6) {\n'
              '    return a;\n'
              '  } else {\n'
              '    return 3;\n'
              '  }',
          'if (a == 9) {\n'
              '    return a;\n'
              '  } else\n'
              '    return 3;',
          'if (a == 10)\n'
              '    return a;\n'
              '  else {\n'
              '    return 3;\n'
              '  }',
          'if (a == 11) {\n'
              '    a = 2;\n'
              '  } else\n'
              '    a = 3;',
          'if (a == 12)\n'
              '    a = 2;\n'
              '  else {\n'
              '    a = 3;\n'
              '  }',
          'if (a == 17)\n'
              '    a = 2;\n'
              '  else\n'
              '    a = 3;',
          'if (a == 20)\n'
              '    return 2;\n'
              '  else\n'
              '    return a;',
        ],
        messages: [
          'Prefer conditional expression',
          'Prefer conditional expression',
          'Prefer conditional expression',
          'Prefer conditional expression',
          'Prefer conditional expression',
          'Prefer conditional expression',
          'Prefer conditional expression',
          'Prefer conditional expression',
        ],
        replacements: [
          'a = a == 3 ? 2 : 3;',
          'return a == 6 ? a : 3;',
          'return a == 9 ? a : 3;',
          'return a == 10 ? a : 3;',
          'a = a == 11 ? 2 : 3;',
          'a = a == 12 ? 2 : 3;',
          'a = a == 17 ? 2 : 3;',
          'return a == 20 ? 2 : a;',
        ],
        replacementComments: [
          'Convert to conditional expression',
          'Convert to conditional expression',
          'Convert to conditional expression',
          'Convert to conditional expression',
          'Convert to conditional expression',
          'Convert to conditional expression',
          'Convert to conditional expression',
          'Convert to conditional expression',
        ],
      );
    });
  });
}
