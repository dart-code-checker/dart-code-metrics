import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/models/rule_type.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rule_utils.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/list_all_equatable_fields/list_all_equatable_fields_rule.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _examplePath = 'list_all_equatable_fields/examples/example.dart';

void main() {
  group('ListAllEquatableFieldsRule', () {
    test('is of type common', () {
      expect(
        ListAllEquatableFieldsRule().type,
        equals(RuleType.common),
      );
    });

    test('has expected documentation path', () {
      final documentationUri = documentation(ListAllEquatableFieldsRule());

      expect(
        documentationUri.path,
        equals('/docs/rules/common/list-all-equatable-fields'),
      );
    });

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
        startLines: [34, 47, 69, 90, 106],
        startColumns: [3, 3, 3, 3, 3],
        locationTexts: [
          'List<Object> get props => [name];',
          'List<Object> get props {\n'
              '    return [name]; // LINT\n'
              '  }',
          'List<Object> get props {\n'
              '    return super.props..addAll([]); // LINT\n'
              '  }',
          'List<Object> get props => super.props..addAll([]);',
          'List<Object> get props {\n'
              '    return [\n'
              '      year,\n'
              '      month,\n'
              '      day,\n'
              '      hour,\n'
              '      minute,\n'
              '      second,\n'
              '      millisecond,\n'
              '      microsecond,\n'
              '      // LINT\n'
              '    ];\n'
              '  }',
        ],
        messages: [
          'Missing declared class fields: age',
          'Missing declared class fields: age, address',
          'Missing declared class fields: value',
          'Missing declared class fields: century',
          'Missing declared class fields: isUtc, millisecondsSinceEpoch, microsecondsSinceEpoch, timeZoneName, timeZoneOffset, weekday',
        ],
      );
    });
  });
}
