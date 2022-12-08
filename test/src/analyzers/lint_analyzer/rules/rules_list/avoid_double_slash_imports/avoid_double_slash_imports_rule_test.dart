import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/avoid_double_slash_imports/avoid_double_slash_imports_rule.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _examplePath = 'avoid_double_slash_imports/examples/example.dart';

void main() {
  group('AvoidDoubleSlashImportsRule', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = AvoidDoubleSlashImportsRule().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'avoid-double-slash-imports',
        severity: Severity.warning,
      );
    });

    test('reports about found issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = AvoidDoubleSlashImportsRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [3, 5],
        startColumns: [1, 1],
        locationTexts: [
          "import '../../..//rule_utils_test.dart';",
          "part '..//empty.dart';",
        ],
        messages: [
          'Avoid double slash import/export directives.',
          'Avoid double slash import/export directives.',
        ],
        replacements: [
          "import '../../../rule_utils_test.dart';",
          "part '../empty.dart';",
        ],
        replacementComments: [
          'Remove double slash.',
          'Remove double slash.',
        ],
      );
    });
  });
}
