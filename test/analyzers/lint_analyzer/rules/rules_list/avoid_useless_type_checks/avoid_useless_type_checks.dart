import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/avoid_useless_type_checks/avoid_useless_type_checks.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _path = 'avoid_useless_type_checks/examples';
const _classExample = '$_path/example.dart';

void main() {
  group('AvoidUselessTypeChecks', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_classExample);
      final issues = AvoidUselessTypeChecks().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'avoid-useless-type-checks',
        severity: Severity.style,
      );
    });

    test('reports about found all issues in example.dart', () async {
      final unit = await RuleTestHelper.resolveFromFile(_classExample);
      final issues = AvoidUselessTypeChecks().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startOffsets: [95, 136],
        startLines: [6, 7],
        startColumns: [20, 21],
        endOffsets: [106, 149],
        locationTexts: [
          'v is String',
          'v2 is String?',
        ],
        messages: [
          'Avoid useless type checks.',
          'Avoid useless type checks.',
        ],
      );
    });
  });
}
