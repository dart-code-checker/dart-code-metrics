import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/avoid_expanded_as_spacer/avoid_expanded_as_spacer_rule.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _examplePath = 'avoid_expanded_as_spacer/examples/example.dart';

void main() {
  group('AvoidExpandedAsSpacerRule', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = AvoidExpandedAsSpacerRule().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'avoid-expanded-as-spacer',
        severity: Severity.style,
      );
    });

    test('reports about found issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = AvoidExpandedAsSpacerRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [3, 4],
        startColumns: [9, 9],
        locationTexts: [
          'Expanded(child: Container())',
          'Expanded(child: SizeBox())',
        ],
        replacementComments: [
          'Replace with Spacer widget.',
          'Replace with Spacer widget.',
        ],
        messages: [
          'Prefer using Spacer widget instead of Expanded.',
          'Prefer using Spacer widget instead of Expanded.',
        ],
        replacements: [
          'const Spacer()',
          'const Spacer()',
        ],
      );
    });
  });
}
