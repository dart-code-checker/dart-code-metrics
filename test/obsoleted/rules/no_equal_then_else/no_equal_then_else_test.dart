@TestOn('vm')
import 'package:dart_code_metrics/src/models/severity.dart';
import 'package:dart_code_metrics/src/obsoleted/rules/no_equal_then_else.dart';
import 'package:test/test.dart';

import '../../../helpers/file_resolver.dart';
import '../../../helpers/rule_test_helper.dart';

// ignore_for_file: no_adjacent_strings_in_list

const _examplePath =
    'test/obsoleted/rules/no_equal_then_else/examples/example.dart';

void main() {
  group('EqualThenElse', () {
    test('initialization', () async {
      final unit = await FileResolver.resolve(_examplePath);
      final issues = NoEqualThenElse().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'no-equal-then-else',
        severity: Severity.warning,
      );
    });

    test('reports about found issues', () async {
      final unit = await FileResolver.resolve(_examplePath);
      final issues = NoEqualThenElse().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startOffsets: [66, 271, 350, 551, 735],
        startLines: [6, 23, 30, 44, 58],
        startColumns: [3, 3, 3, 10, 12],
        endOffsets: [137, 336, 405, 616, 765],
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
          'Then and else branches are equal',
          'Then and else branches are equal',
          'Then and else branches are equal',
          'Then and else branches are equal',
          'Then and else branches are equal',
        ],
      );
    });
  });
}
