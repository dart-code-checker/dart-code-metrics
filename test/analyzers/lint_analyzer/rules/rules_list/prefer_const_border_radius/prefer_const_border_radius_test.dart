import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/prefer_const_border_radius/prefer_const_border_radius.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _examplePath = 'prefer_const_border_radius/example';
const _withSingleClass = '$_examplePath/example.dart';

void main() {
  test('reports border const', () async {
    final unit = await RuleTestHelper.resolveFromFile(_withSingleClass);
    final issues = PreferConstBorderRadius().check(unit);

    RuleTestHelper.verifyIssues(
      issues: issues,
      startOffsets: [164],
      startLines: [7],
      startColumns: [3],
      endOffsets: [188],
      messages: ['Prefer const border radius'],
      locationTexts: ['BorderRadius.circular();'],
    );
  });
}
