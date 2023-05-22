import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/avoid_edgesinset_only/avoid_edgeinsets_only_rule.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _examplePath = 'avoid_edgeinsets_only_rule/examples/example.dart';

void main() {
  group('AvoidEdgeInsetsOnlyRule', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = AvoidEdgeInsetsOnlyRule().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'avoid-edgeinsets-only',
        severity: Severity.error,
      );
    });

    test('reports about all found issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);

      final issues = AvoidEdgeInsetsOnlyRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [81, 86],
        startColumns: [31, 18],
        locationTexts: [
          "EdgeInsets.only(left: 20)",
          "EdgeInsets.only(left: 20, right: 2, top: 1)"
        ],
        replacementComments: [
          'Replace with EdgeInsetsDirectional.only',
          'Replace with EdgeInsetsDirectional.only',
        ],
        messages: [
          'EdgeInsets.only is not allowed due to Arabic support, use EdgeInsetsDirectional instead',
          'EdgeInsets.only is not allowed due to Arabic support, use EdgeInsetsDirectional instead',
        ],
        replacements: [
          'EdgeInsetsDirectional.only(leading: 20)',
          'EdgeInsetsDirectional.only(leading: 20, trailing: 2, top: 1)',
        ],
      );
    });
  });
}
