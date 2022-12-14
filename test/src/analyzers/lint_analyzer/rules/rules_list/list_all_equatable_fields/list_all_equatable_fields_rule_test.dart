import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/list_all_equatable_fields/list_all_equatable_fields_rule.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _examplePath = 'list_all_equatable_fields/examples/example.dart';

void main() {
  group('ListAllEquatableFieldsRule', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = ListAllEquatableFieldsRule().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'list-all-equatable-fields',
        severity: Severity.warning,
      );
    });

    test('reports about found issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = ListAllEquatableFieldsRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [34, 47],
        startColumns: [3, 3],
        locationTexts: [
          'List<Object> get props => [name];',
          'List<Object> get props {\n'
              '    return [name];  // LINT\n'
              '  }',
        ],
        messages: [
          'Missing declared class fields: age',
          'Missing declared class fields: age, address',
        ],
      );
    });
  });
}
