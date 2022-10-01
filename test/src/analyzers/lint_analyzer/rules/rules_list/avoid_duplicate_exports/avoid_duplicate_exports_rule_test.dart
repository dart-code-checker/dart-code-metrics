import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/avoid_duplicate_exports/avoid_duplicate_exports_rule.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _examplePath = 'avoid_duplicate_exports/examples/example.dart';

void main() {
  group('AvoidDuplicateExportsRule', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = AvoidDuplicateExportsRule().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'avoid-duplicate-exports',
        severity: Severity.warning,
      );
    });

    test('reports about all found issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);

      final issues = AvoidDuplicateExportsRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [6],
        startColumns: [1],
        locationTexts: [
          "export 'package:intl/good_folder/something.dart';",
        ],
        messages: [
          'Avoid declaring duplicate exports.',
        ],
      );
    });
  });
}
