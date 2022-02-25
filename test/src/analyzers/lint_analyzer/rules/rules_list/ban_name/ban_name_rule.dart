import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/ban_name/ban_name_rule.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _examplePath = 'always_remove_listener/examples/example.dart';

void main() {
  group('BanNameRule', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = BanNameRule().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'prefer-correct-type-name',
        severity: Severity.style,
      );
    });

    test('reports about all found issues in example.dart', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);

      final issues = BanNameRule({
        'entries': [
          {'ident': 'showDialog', 'description': 'Please use myShowDialog'},
          {'ident': 'showSnackBar', 'description': 'What about myShowSnackBar'},
        ],
      }).check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [],
        startColumns: [],
        locationTexts: [],
        messages: [],
      );
    });
  });
}
