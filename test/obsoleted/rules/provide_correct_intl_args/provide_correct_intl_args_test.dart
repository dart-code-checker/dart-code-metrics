@TestOn('vm')
import 'package:dart_code_metrics/src/models/severity.dart';
import 'package:dart_code_metrics/src/obsoleted/rules/provide_correct_intl_args.dart';
import 'package:test/test.dart';

import '../../../helpers/rule_test_helper.dart';

const _examplePath =
    'test/obsoleted/rules/provide_correct_intl_args/examples/example.dart';
const _incorrectExamplePath =
    'test/obsoleted/rules/provide_correct_intl_args/examples/incorrect_example.dart';

void main() {
  group('PreferIntlArgsRule', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = ProvideCorrectIntlArgsRule().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'provide-correct-intl-args',
        severity: Severity.warning,
      );
    });

    test('reports no issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = ProvideCorrectIntlArgsRule().check(unit);

      RuleTestHelper.verifyNoIssues(issues);
    });

    test('reports about found issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_incorrectExamplePath);
      final issues = ProvideCorrectIntlArgsRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startOffsets: [
          174,
          182,
          182,
          182,
          486,
          487,
          393,
          674,
          675,
          882,
          1214,
          1519,
          1383,
          1424,
          1604,
          1658,
          1971,
          1872,
          2055,
          2109,
          2444,
          2336,
        ],
        startLines: [
          7,
          7,
          7,
          7,
          17,
          17,
          15,
          23,
          23,
          29,
          39,
          47,
          44,
          45,
          50,
          51,
          59,
          57,
          62,
          63,
          71,
          69,
        ],
        startColumns: [
          45,
          53,
          53,
          53,
          15,
          16,
          33,
          15,
          16,
          23,
          34,
          16,
          56,
          33,
          68,
          47,
          23,
          47,
          72,
          47,
          23,
          47,
        ],
        endOffsets: [
          187,
          186,
          186,
          186,
          492,
          491,
          397,
          680,
          679,
          886,
          1223,
          1528,
          1388,
          1429,
          1608,
          1662,
          1975,
          1876,
          2059,
          2113,
          2448,
          2340,
        ],
        locationTexts: [
          '(String name)',
          'name',
          'name',
          'name',
          '[name]',
          'name',
          'name',
          '[name]',
          'name',
          'name',
          'value + 1',
          'value + 1',
          'value',
          'value',
          'name',
          'name',
          'name',
          'name',
          'name',
          'name',
          'name',
          'name',
        ],
        messages: [
          'Parameter "args" should be added',
          'Parameter should be added to args',
          'Parameter is unused and should be removed',
          'Item is unused and should be removed',
          'Parameter "args" should be removed',
          'Args item should be added to parameters',
          'Interpolation expression should be added to parameters',
          'Parameter "args" should be removed',
          'Args item should be added to parameters',
          'Args item should be added to parameters',
          'Item should be simple identifier',
          'Item should be simple identifier',
          'Parameter should be added to args',
          'Interpolation expression should be added to args',
          'Parameter should be added to args',
          'Interpolation expression should be added to args',
          'Args item should be added to parameters',
          'Interpolation expression should be added to parameters',
          'Parameter should be added to args',
          'Interpolation expression should be added to args',
          'Args item should be added to parameters',
          'Interpolation expression should be added to parameters',
        ],
      );
    });
  });
}
