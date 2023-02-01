import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/avoid_redundant_async_on_load/avoid_redundant_async_on_load_rule.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _examplePath = 'avoid_redundant_async_on_load/examples/example.dart';

void main() {
  group('AvoidRedundantAsyncOnLoadRule', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = AvoidRedundantAsyncOnLoadRule().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'avoid-redundant-async-on-load',
        severity: Severity.warning,
      );
    });

    test('reports about found issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = AvoidRedundantAsyncOnLoadRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [6, 14, 22],
        startColumns: [3, 3, 3],
        locationTexts: [
          'Future<void> onLoad() {\n'
              "    print('hello');\n"
              '  }',
          'FutureOr<void> onLoad() {\n'
              "    print('hello');\n"
              '  }',
          'FutureOr<void> onLoad() async {\n'
              "    print('hello');\n"
              '  }',
        ],
        messages: [
          "Avoid unnecessary async 'onLoad'.",
          "Avoid unnecessary async 'onLoad'.",
          "Avoid unnecessary async 'onLoad'.",
        ],
      );
    });
  });
}
