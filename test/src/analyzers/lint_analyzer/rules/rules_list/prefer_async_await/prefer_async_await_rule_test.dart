import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/prefer_async_await/prefer_async_await_rule.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _examplePath = 'prefer_async_await/examples/example.dart';

void main() {
  group('PreferAsyncAwaitRule', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = PreferAsyncAwaitRule().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'prefer-async-await',
        severity: Severity.style,
      );
    });

    test('reports about found issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = PreferAsyncAwaitRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [6, 8, 12, 18],
        startColumns: [3, 9, 25, 10],
        locationTexts: [
          'future.then((value) => print(value))',
          '..then((value) => print(value))',
          'getFuture().then((value) => value + 5)',
          'Future.delayed(Duration(microseconds: 100), () => 5)\n'
              '      .then((value) => value + 1)',
        ],
        messages: [
          'Prefer using async/await syntax instead of .then invocations',
          'Prefer using async/await syntax instead of .then invocations',
          'Prefer using async/await syntax instead of .then invocations',
          'Prefer using async/await syntax instead of .then invocations',
        ],
      );
    });
  });
}
