import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/prefer_enums_by_name/prefer_enums_by_name_rule.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _examplePath = 'prefer_enums_by_name/examples/example.dart';

void main() {
  group('PreferEnumsByNameRule', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = PreferEnumsByNameRule().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'prefer-enums-by-name',
        severity: Severity.style,
      );
    });

    test('reports about found issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = PreferEnumsByNameRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [6, 8],
        startColumns: [3, 3],
        locationTexts: [
          "SomeEnums.values.firstWhere((element) => element.name == 'first')",
          'SomeEnums.values\n'
              "      .firstWhere((element) => element.name == 'second', orElse: () => null)",
        ],
        messages: [
          'Prefer using values.byName',
          'Prefer using values.byName',
        ],
      );
    });
  });
}
