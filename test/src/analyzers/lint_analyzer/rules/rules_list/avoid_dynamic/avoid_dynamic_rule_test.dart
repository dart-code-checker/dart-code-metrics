import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/avoid_dynamic/avoid_dynamic_rule.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _examplePath = 'avoid_dynamic/examples/example.dart';

void main() {
  group('AvoidDynamicRule', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = AvoidDynamicRule().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'avoid-dynamic',
        severity: Severity.warning,
      );
    });

    test('reports about found issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = AvoidDynamicRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [2, 6, 10, 10, 10, 12, 23, 28, 31, 39],
        startColumns: [3, 4, 1, 22, 33, 7, 3, 3, 3, 32],
        locationTexts: [
          'dynamic s = 1',
          's as dynamic',
          'dynamic someFunction(dynamic a, dynamic b) {\n'
              '  // LINT\n'
              '  if (a is dynamic) {\n'
              '    return b;\n'
              '  }\n'
              '\n'
              '  return a + b;\n'
              '}',
          'dynamic a',
          'dynamic b',
          'a is dynamic',
          'final dynamic value',
          'dynamic get state => value;',
          'dynamic calculate() {\n'
              '    return value;\n'
              '  }',
          '<dynamic>',
        ],
        messages: [
          'Avoid using dynamic type.',
          'Avoid using dynamic type.',
          'Avoid using dynamic type.',
          'Avoid using dynamic type.',
          'Avoid using dynamic type.',
          'Avoid using dynamic type.',
          'Avoid using dynamic type.',
          'Avoid using dynamic type.',
          'Avoid using dynamic type.',
          'Avoid using dynamic type.',
        ],
      );
    });
  });
}
