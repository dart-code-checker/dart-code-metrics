import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/ban_name/ban_name_rule.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _examplePath = 'ban_name/examples/example.dart';

void main() {
  group('BanNameRule', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = BanNameRule().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'ban-name',
        severity: Severity.warning,
      );
    });

    test('reports about all found issues in example.dart', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);

      final issues = BanNameRule({
        'entries': [
          {'ident': 'showDialog', 'description': 'Please use myShowDialog'},
          {'ident': 'strangeName', 'description': 'The name is too strange'},
          {'ident': 'AnotherStrangeName', 'description': 'Oops'},
          {
            'ident': 'StrangeClass.someMethod',
            'description': 'Please use NonStrangeClass.someMethod instead',
          },
          {
            'ident': 'DateTime.now',
            'description': 'Please use clock.now instead',
          },
        ],
      }).check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [7, 8, 10, 13, 16, 17, 21, 24, 25, 26, 32],
        startColumns: [3, 12, 7, 1, 1, 12, 3, 3, 3, 3, 28],
        locationTexts: [
          'showDialog',
          'showDialog',
          'strangeName = 42',
          'void strangeName() {}',
          'class AnotherStrangeName {\n'
              '  late var strangeName; // LINT\n'
              '}',
          'strangeName',
          'StrangeClass.someMethod',
          'DateTime.now',
          'DateTime.now',
          'DateTime.now',
          'DateTime.now',
        ],
        messages: [
          'Please use myShowDialog (showDialog is banned)',
          'Please use myShowDialog (showDialog is banned)',
          'The name is too strange (strangeName is banned)',
          'The name is too strange (strangeName is banned)',
          'Oops (AnotherStrangeName is banned)',
          'The name is too strange (strangeName is banned)',
          'Please use NonStrangeClass.someMethod instead (StrangeClass.someMethod is banned)',
          'Please use clock.now instead (DateTime.now is banned)',
          'Please use clock.now instead (DateTime.now is banned)',
          'Please use clock.now instead (DateTime.now is banned)',
          'Please use clock.now instead (DateTime.now is banned)',
        ],
      );
    });
  });
}
