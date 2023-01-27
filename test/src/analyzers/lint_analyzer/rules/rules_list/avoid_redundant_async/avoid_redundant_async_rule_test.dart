import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/avoid_redundant_async/avoid_redundant_async_rule.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _examplePath = 'avoid_redundant_async/examples/example.dart';

void main() {
  group('AvoidRedundantAsyncRule', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = AvoidRedundantAsyncRule().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'avoid-redundant-async',
        severity: Severity.warning,
      );
    });

    test('reports about found issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = AvoidRedundantAsyncRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [12, 22, 59, 60],
        startColumns: [26, 3, 5, 22],
        locationTexts: [
          '(Future<int> left, Future<int> right) async {\n'
              '  return Future.any([left, right]);\n'
              '}',
          "Future<String> anotherAsyncMethod() async => Future.value('value');",
          '() async => instance.someAsyncMethod()',
          '() async => instance.someAsyncMethod()',
        ],
        messages: [
          "'async' keyword is redundant, consider removing it.",
          "'async' keyword is redundant, consider removing it.",
          "'async' keyword is redundant, consider removing it.",
          "'async' keyword is redundant, consider removing it.",
        ],
      );
    });
  });
}
