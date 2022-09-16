import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/check_for_equals_in_render_object_setters/check_for_equals_in_render_object_setters_rule.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _examplePath =
    'check_for_equals_in_render_object_setters/examples/example.dart';

void main() {
  group('CheckForEqualsInRenderObjectSettersRule', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = CheckForEqualsInRenderObjectSettersRule().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'check-for-equals-in-render-object-setters',
        severity: Severity.warning,
      );
    });

    test('reports about found issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = CheckForEqualsInRenderObjectSettersRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [29, 37, 61],
        startColumns: [3, 3, 3],
        locationTexts: [
          'set dividerWidth(double value) {\n'
              '    _dividerWidth = value;\n'
              '    markNeedsLayout();\n'
              '  }',
          'set dividerHeight(double value) {\n'
              '    if (_dividerHeight == _dividerWidth) {\n'
              '      return;\n'
              '    }\n'
              '\n'
              '    _dividerHeight = value;\n'
              '    markNeedsLayout();\n'
              '  }',
          'set spacing(double value) {\n'
              '    _spacing = value;\n'
              '\n'
              '    if (_spacing == value) {\n'
              '      return;\n'
              '    }\n'
              '    markNeedsLayout();\n'
              '  }',
        ],
        messages: [
          'Equals check is missing.',
          'Equals check compares a wrong parameter or has no return statement.',
          'Equals check should come first in the block.',
        ],
      );
    });
  });
}
