import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/avoid_cascade_after_if_null/avoid_cascade_after_if_null_rule.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _examplePath = 'avoid_cascade_after_if_null/examples/example.dart';

void main() {
  group('AvoidCascadeAfterIfNullRule', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = AvoidCascadeAfterIfNullRule().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'avoid-cascade-after-if-null',
        severity: Severity.warning,
      );
    });

    test('reports about found issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = AvoidCascadeAfterIfNullRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [9, 16],
        startColumns: [16, 15],
        locationTexts: [
          'cow ?? Cow()\n'
              '          ..moo()',
          'nullableCow ?? Cow()\n'
              '    ..moo()',
        ],
        messages: [
          'Avoid using cascade after ?? without precedence. It might lead to unexpected errors.',
          'Avoid using cascade after ?? without precedence. It might lead to unexpected errors.',
        ],
      );
    });
  });
}
