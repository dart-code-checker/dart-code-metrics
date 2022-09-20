import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/consistent_update_render_object/consistent_update_render_object_rule.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _correctExamplePath =
    'consistent_update_render_object/examples/correct_example.dart';
const _incorrectExamplePath =
    'consistent_update_render_object/examples/incorrect_example.dart';

void main() {
  group('ConsistentUpdateRenderObjectRule', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_correctExamplePath);
      final issues = ConsistentUpdateRenderObjectRule().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'consistent-update-render-object',
        severity: Severity.warning,
      );
    });

    test('reports no issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_correctExamplePath);
      final issues = ConsistentUpdateRenderObjectRule().check(unit);

      RuleTestHelper.verifyNoIssues(issues);
    });

    test('reports about found issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_incorrectExamplePath);
      final issues = ConsistentUpdateRenderObjectRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [42, 52, 98],
        startColumns: [3, 1, 3],
        locationTexts: [
          'void updateRenderObject(BuildContext context, _RenderMenuItem renderObject) {}',
          'class ColorFiltered extends SingleChildRenderObjectWidget {\n'
              '  const ColorFiltered({required this.value});\n'
              '\n'
              '  final int value;\n'
              '\n'
              '  @override\n'
              '  RenderObject createRenderObject(BuildContext context) =>\n'
              '      _ColorFilterRenderObject(colorFilter);\n'
              '}',
          'void updateRenderObject(\n'
              '    BuildContext context,\n'
              '    _RenderDecoration renderObject,\n'
              '  ) {\n'
              '    renderObject\n'
              '      ..expands = expands\n'
              '      ..textDirection = textDirection;\n'
              '  }',
        ],
        messages: [
          "updateRenderObject method doesn't update all parameters, that are set in createRenderObject",
          'Implementation for updateRenderObject method is absent.',
          "updateRenderObject method doesn't update all parameters, that are set in createRenderObject",
        ],
      );
    });
  });
}
