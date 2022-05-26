import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/avoid_banned_imports/avoid_banned_imports_rule.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _examplePath = 'avoid_banned_imports/examples/example.dart';

void main() {
  group('AvoidBannedImportsRule', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = AvoidBannedImportsRule().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'ban-name',
        severity: Severity.style,
      );
    });

    test('reports about all found issues in example.dart', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);

      final issues = AvoidBannedImportsRule({
        'entries': <Object>[
          // TODO
          // <String, Object>{
          //   'paths': [TODO],
          //   'deny': [TODO],
          //   'message': TODO,
          // },
        ],
      }).check(unit);

      // TODO
      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [],
        startColumns: [],
        locationTexts: [],
        messages: [],
      );
    });
  });
}
