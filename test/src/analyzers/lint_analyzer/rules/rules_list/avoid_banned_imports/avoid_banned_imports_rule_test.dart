import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/avoid_banned_imports/avoid_banned_imports_rule.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _examplePath = 'avoid_banned_imports/examples/example.dart';

void main() {
  group('AvoidBannedImportsRule', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = AvoidBannedImportsRule().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'avoid-banned-imports',
        severity: Severity.warning,
      );
    });

    test('reports about all found issues in example.dart', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);

      final issues = AvoidBannedImportsRule({
        'entries': <Object>[
          <String, Object>{
            'paths': [
              r'.*examples.*\.dart',
            ],
            'deny': [
              'package:test/.*',
              'package:intl/ban_folder/.*',
            ],
            'message': 'sample message',
          },
        ],
      }).check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [1, 4],
        startColumns: [1, 1],
        locationTexts: [
          "import 'package:test/material.dart';",
          "import 'package:intl/ban_folder/something.dart';",
        ],
        messages: [
          'Avoid banned imports (sample message).',
          'Avoid banned imports (sample message).',
        ],
      );
    });
  });
}
