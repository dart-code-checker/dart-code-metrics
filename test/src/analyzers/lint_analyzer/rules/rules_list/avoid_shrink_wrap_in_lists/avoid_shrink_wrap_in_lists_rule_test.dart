import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/avoid_shrink_wrap_in_lists/avoid_shrink_wrap_in_lists_rule.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _examplePath = 'avoid_shrink_wrap_in_lists/examples/example.dart';

void main() {
  group('AvoidShrinkWrapInListsRule', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = AvoidShrinkWrapInListsRule().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'avoid-shrink-wrap-in-lists',
        severity: Severity.performance,
      );
    });

    test('reports about found issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = AvoidShrinkWrapInListsRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [10, 17, 24],
        startColumns: [30, 27, 32],
        locationTexts: [
          'ListView(shrinkWrap: true, children: [])',
          'ListView(shrinkWrap: true, children: [])',
          'ListView(shrinkWrap: true, children: [])',
        ],
        messages: [
          'Avoid using ListView with shrinkWrap, since it might degrade the performance. Consider using slivers instead.',
          'Avoid using ListView with shrinkWrap, since it might degrade the performance. Consider using slivers instead.',
          'Avoid using ListView with shrinkWrap, since it might degrade the performance. Consider using slivers instead.',
        ],
      );
    });
  });
}
