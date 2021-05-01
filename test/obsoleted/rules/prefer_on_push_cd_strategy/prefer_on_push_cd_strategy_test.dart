@TestOn('vm')
import 'package:dart_code_metrics/src/models/severity.dart';
import 'package:dart_code_metrics/src/obsoleted/rules/prefer_on_push_cd_strategy.dart';
import 'package:test/test.dart';

import '../../../helpers/file_resolver.dart';
import '../../../helpers/rule_test_helper.dart';

const _examplePath =
    'test/obsoleted/rules/prefer_on_push_cd_strategy/examples/example.dart';
const _missingExamplePath =
    'test/obsoleted/rules/prefer_on_push_cd_strategy/examples/missing_example.dart';
const _incorrectExamplePath =
    'test/obsoleted/rules/prefer_on_push_cd_strategy/examples/incorrect_example.dart';

void main() {
  group('PreferOnPushCdStrategy', () {
    test('initialization', () async {
      final unit = await FileResolver.resolve(_examplePath);
      final issues = PreferOnPushCdStrategyRule().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'prefer-on-push-cd-strategy',
        severity: Severity.warning,
      );
    });

    test('reports no issues', () async {
      final unit = await FileResolver.resolve(_examplePath);
      final issues = PreferOnPushCdStrategyRule().check(unit);

      RuleTestHelper.verifyNoIssues(issues);
    });

    test('reports about missing OnPush change detection strategy', () async {
      final unit = await FileResolver.resolve(_missingExamplePath);
      final issues = PreferOnPushCdStrategyRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [2],
        messages: ['Prefer using onPush change detection strategy.'],
      );
    });

    test('reports about incorrect OnPush change detection strategy', () async {
      final unit = await FileResolver.resolve(_incorrectExamplePath);
      final issues = PreferOnPushCdStrategyRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [3],
        messages: ['Prefer using onPush change detection strategy.'],
      );
    });
  });
}
