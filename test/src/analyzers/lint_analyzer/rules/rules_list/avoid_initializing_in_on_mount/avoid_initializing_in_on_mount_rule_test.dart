import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/avoid_initializing_in_on_mount/avoid_initializing_in_on_mount_rule.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _examplePath = 'avoid_initializing_in_on_mount/examples/example.dart';

void main() {
  group('AvoidInitializingInOnMountRule', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = AvoidInitializingInOnMountRule().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'avoid-initializing-in-on-mount',
        severity: Severity.warning,
      );
    });

    test('reports about found issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = AvoidInitializingInOnMountRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [8],
        startColumns: [5],
        locationTexts: ['x = 1'],
        messages: [
          'Avoid initializing final late variables in onMount.',
        ],
      );
    });
  });
}
