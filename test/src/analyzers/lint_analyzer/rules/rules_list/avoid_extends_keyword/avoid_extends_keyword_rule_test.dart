import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/avoid_extends_keyword/avoid_extends_keyword_rule.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/avoid_global_state/avoid_global_state_rule.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _examplePath = 'avoid_extends_keyword/examples/example.dart';

void main() {
  group('AvoidExtendsKeyword', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = AvoidExtendsKeywordRule().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'avoid-extends-keyword',
        severity: Severity.style,
      );
    });

    test('reports about found issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = AvoidExtendsKeywordRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [3, 9, 17, 21],
        startColumns: [1,1,1,1],
        locationTexts: [
          'class B extends A {}',
          'class D extends C { // LINT\n'
              '  // Implementation\n'
              '}',
          'abstract class G extends E { // LINT\n'
              '  String get b;\n'
              '}',
          'class K extends G { // LINT\n'
              '  // Implementation\n'
              '}',
        ],
        messages: [
          'Prefer using implements keyword for abstract classes',
          'Prefer using implements keyword for abstract classes',
          'Prefer using implements keyword for abstract classes',
          'Prefer using implements keyword for abstract classes',
        ],
      );
    });
  });
}
