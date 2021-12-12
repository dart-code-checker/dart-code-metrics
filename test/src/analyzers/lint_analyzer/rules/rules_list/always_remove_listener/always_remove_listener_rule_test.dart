import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/always_remove_listener/always_remove_listener_rule.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _examplePath = 'always_remove_listener/examples/example.dart';
const _valueNotifierExamplePath =
    'always_remove_listener/examples/value_notifier_example.dart';

void main() {
  group('AlwaysRemoveListenerRule', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = AlwaysRemoveListenerRule().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'always-remove-listener',
        severity: Severity.warning,
      );
    });

    test('reports about found issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = AlwaysRemoveListenerRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [21, 22, 25, 30, 38, 40],
        startColumns: [5, 5, 5, 7, 5, 5],
        locationTexts: [
          '_anotherListener.addListener(listener)',
          '_thirdListener.addListener(listener)',
          'widget.someListener.addListener(listener)',
          '..addListener(() {})',
          'widget.anotherListener.addListener(listener)',
          '_someListener.addListener(listener)',
        ],
        messages: [
          'Listener is not removed. This might lead to a memory leak.',
          'Listener is not removed. This might lead to a memory leak.',
          'Listener is not removed. This might lead to a memory leak.',
          'Listener is not removed. This might lead to a memory leak.',
          'Listener is not removed. This might lead to a memory leak.',
          'Listener is not removed. This might lead to a memory leak.',
        ],
      );
    });

    test('should report no issues for value notifier', () async {
      final unit =
          await RuleTestHelper.resolveFromFile(_valueNotifierExamplePath);
      final issues = AlwaysRemoveListenerRule().check(unit);

      RuleTestHelper.verifyNoIssues(issues);
    });
  });
}
