import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/avoid_passing_async_when_sync_expected/avoid_passing_async_when_sync_expected_rule.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _examplePath =
    'avoid_passing_async_when_sync_expected/examples/example.dart';

void main() {
  group('AvoidPassingAsyncWhenSyncExpectedRule', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = AvoidPassingAsyncWhenSyncExpectedRule().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'avoid-passing-async-when-sync-expected',
        severity: Severity.warning,
      );
    });

    test('reports about found issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = AvoidPassingAsyncWhenSyncExpectedRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [49, 54, 57, 87],
        startColumns: [7, 7, 7, 9],
        locationTexts: [
          'synchronousWork: work1',
          'synchronousWork3: () async {\n'
              "        print('work 3');\n"
              '      }',
          'synchronousWork4: work4',
          'onPressed: () async {\n'
              '          await Future.delayed(const Duration(seconds: 1));\n'
              '          _incrementCounter();\n'
              '        }',
        ],
        messages: [
          'Expected a sync function but got async.',
          'Expected a sync function but got async.',
          'Expected a sync function but got async.',
          'Expected a sync function but got async.',
        ],
      );
    });
  });
}
