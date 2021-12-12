import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/no_equal_then_else/no_equal_then_else_rule.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _examplePath = 'no_equal_then_else/examples/example.dart';

void main() {
  group('NoEqualThenElseRule', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = NoEqualThenElseRule().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'no-equal-then-else',
        severity: Severity.warning,
      );
    });

    test('reports about found issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = NoEqualThenElseRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [6, 23, 30, 44, 58],
        startColumns: [3, 3, 3, 10, 12],
        locationTexts: [
          'if (value1 == 1) {\n'
              '    return value1;\n'
              '  } else {\n'
              '    return value1;\n'
              '  }',
          'if (value1 == 4) {\n'
              '    value1 = 2;\n'
              '  } else {\n'
              '    value1 = 2;\n'
              '  }',
          'if (value1 == 5)\n'
              '    value1 = 2;\n'
              '  else\n'
              '    value1 = 2;',
          'if (value1 == 9) {\n'
              '    value1 = 5;\n'
              '  } else {\n'
              '    value1 = 5;\n'
              '  }',
          'value1 == 11 ? value1 : value1',
        ],
        messages: [
          'Then and else branches are equal.',
          'Then and else branches are equal.',
          'Then and else branches are equal.',
          'Then and else branches are equal.',
          'Then and else branches are equal.',
        ],
      );
    });
  });
}
