import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/avoid_throw_in_catch_block/avoid_throw_in_catch_block_rule.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _examplePath = 'avoid_throw_in_catch_block/examples/example.dart';

void main() {
  group('AvoidThrowInCatchBlockRule', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = AvoidThrowInCatchBlockRule().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'avoid-throw-in-catch-block',
        severity: Severity.warning,
      );
    });

    test('reports about found issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = AvoidThrowInCatchBlockRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [17, 25],
        startColumns: [5, 5],
        locationTexts: [
          'throw RepositoryException()',
          'throw DataProviderException()',
        ],
        messages: [
          'Call throw in a catch block loses the original stack trace and the original exception.',
          'Call throw in a catch block loses the original stack trace and the original exception.',
        ],
      );
    });
  });
}
