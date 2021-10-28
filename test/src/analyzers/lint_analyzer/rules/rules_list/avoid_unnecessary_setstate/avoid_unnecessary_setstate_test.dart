@TestOn('vm')
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/avoid_unnecessary_setstate/avoid_unnecessary_setstate.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _examplePath = 'avoid_unnecessary_setstate/examples/example.dart';
const _stateSubclassExamplePath =
    'avoid_unnecessary_setstate/examples/state_subclass_example.dart';

void main() {
  group('AvoidUnnecessarySetStateRule', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = AvoidUnnecessarySetStateRule().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'avoid-unnecessary-setstate',
        severity: Severity.warning,
      );
    });

    test('reports about found issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = AvoidUnnecessarySetStateRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startOffsets: [302, 392, 606, 941, 1031, 455, 1294],
        startLines: [16, 22, 35, 57, 63, 27, 78],
        startColumns: [5, 7, 5, 5, 7, 5, 5],
        endOffsets: [348, 442, 652, 987, 1081, 465, 1304],
        locationTexts: [
          'setState(() {\n'
              '      myString = "Hello";\n'
              '    })',
          'setState(() {\n'
              '        myString = "Hello";\n'
              '      })',
          'setState(() {\n'
              '      myString = "Hello";\n'
              '    })',
          'setState(() {\n'
              '      myString = "Hello";\n'
              '    })',
          'setState(() {\n'
              '        myString = "Hello";\n'
              '      })',
          'myMethod()',
          'myMethod()',
        ],
        messages: [
          'Avoid calling unnecessary setState. Consider changing the state directly.',
          'Avoid calling unnecessary setState. Consider changing the state directly.',
          'Avoid calling unnecessary setState. Consider changing the state directly.',
          'Avoid calling unnecessary setState. Consider changing the state directly.',
          'Avoid calling unnecessary setState. Consider changing the state directly.',
          'Avoid calling a sync method with setState.',
          'Avoid calling a sync method with setState.',
        ],
      );
    });

    test('reports no issues with State subclass', () async {
      final unit =
          await RuleTestHelper.resolveFromFile(_stateSubclassExamplePath);
      final issues = AvoidUnnecessarySetStateRule().check(unit);

      RuleTestHelper.verifyNoIssues(issues);
    });
  });
}
