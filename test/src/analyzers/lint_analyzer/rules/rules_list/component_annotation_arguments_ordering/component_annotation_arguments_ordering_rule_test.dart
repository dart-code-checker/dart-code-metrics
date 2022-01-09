import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/component_annotation_arguments_ordering/component_annotation_arguments_ordering_rule.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _examplePath =
    'component_annotation_arguments_ordering/examples/example.dart';

void main() {
  group('ComponentAnnotationArgumentsOrderingRule', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = ComponentAnnotationArgumentsOrderingRule().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'component-annotation-arguments-ordering',
        severity: Severity.style,
      );
    });

    test('with default config reports about found issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = ComponentAnnotationArgumentsOrderingRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [5],
        startColumns: [3],
        locationTexts: ['styleUrls: []'],
        messages: ['Arguments group styles should be before change-detection.'],
      );
    });

    test('with custom config reports no issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final config = {
        'order': [
          'selector',
          'templates',
        ],
      };

      final issues =
          ComponentAnnotationArgumentsOrderingRule(config).check(unit);

      RuleTestHelper.verifyNoIssues(issues);
    });

    test('with custom config reports about found issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final config = {
        'order': [
          'change-detection',
          'templates',
          'selector',
          'styles',
        ],
      };

      final issues =
          ComponentAnnotationArgumentsOrderingRule(config).check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [3, 4],
        startColumns: [3, 3],
        locationTexts: [
          "template: '<div></div>'",
          'changeDetection: ChangeDetectionStrategy.OnPush',
        ],
        messages: [
          'Arguments group templates should be before selector.',
          'Arguments group change-detection should be before templates.',
        ],
      );
    });
  });
}
