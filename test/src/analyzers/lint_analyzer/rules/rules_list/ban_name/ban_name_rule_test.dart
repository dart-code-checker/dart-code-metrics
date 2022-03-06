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
        severity: Severity.style,
      );
    });

    test('reports about all found issues in example.dart', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);

      final issues = BanNameRule({
        'entries': [
          {'ident': 'showDialog', 'description': 'Please use myShowDialog'},
          {'ident': 'strangeName', 'description': 'The name is too strange'},
          {'ident': 'AnotherStrangeName', 'description': 'Oops'},
        ],
      }).check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [6, 7, 9, 12, 15, 16],
        startColumns: [3, 12, 7, 6, 7, 12],
        locationTexts: [
          'showDialog',
          'showDialog',
          'strangeName',
          'strangeName',
          'AnotherStrangeName',
          'strangeName',
        ],
        messages: [
          'Please use myShowDialog (showDialog is banned)',
          'Please use myShowDialog (showDialog is banned)',
          'The name is too strange (strangeName is banned)',
          'The name is too strange (strangeName is banned)',
          'Oops (AnotherStrangeName is banned)',
          'The name is too strange (strangeName is banned)',
        ],
      );
    });
  });
}
