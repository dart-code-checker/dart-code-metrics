import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/avoid_missing_enum_constant_in_map/avoid_missing_enum_constant_in_map_rule.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _examplePath = 'avoid_missing_enum_constant_in_map/examples/example.dart';

void main() {
  group('AvoidMissingEnumConstantInMapRule', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = AvoidMissingEnumConstantInMapRule().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'avoid-missing-enum-constant-in-map',
        severity: Severity.warning,
      );
    });

    test('reports about found issues with the default config', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = AvoidMissingEnumConstantInMapRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [9, 15, 15],
        startColumns: [16, 16, 16],
        locationTexts: [
          '_code = <CountyCode, String>{\n'
              "    CountyCode.russia: 'RUS',\n"
              "    CountyCode.another: 'XXX',\n"
              '  }',
          '_title = <CountyCode, String>{\n'
              "    CountyCode.russia: 'Россия',\n"
              '  }',
          '_title = <CountyCode, String>{\n'
              "    CountyCode.russia: 'Россия',\n"
              '  }',
        ],
        messages: [
          'Missing map entry for kazachstan',
          'Missing map entry for kazachstan',
          'Missing map entry for another',
        ],
      );
    });
  });
}
