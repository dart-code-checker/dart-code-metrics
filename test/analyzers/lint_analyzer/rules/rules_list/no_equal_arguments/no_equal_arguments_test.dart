@TestOn('vm')
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/no_equal_arguments/no_equal_arguments.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _examplePath = 'no_equal_arguments/examples/example.dart';
const _incorrectExamplePath =
    'no_equal_arguments/examples/incorrect_example.dart';
const _namedParametersExamplePath =
    'no_equal_arguments/examples/named_parameters_example.dart';

void main() {
  group('NoEqualArgumentsRule', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = NoEqualArgumentsRule().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'no-equal-arguments',
        severity: Severity.warning,
      );
    });

    test('reports about found issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_incorrectExamplePath);
      final issues = NoEqualArgumentsRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startOffsets: [328, 669, 753, 842, 942, 1068, 1170],
        startLines: [17, 32, 37, 42, 47, 54, 59],
        startColumns: [5, 5, 5, 5, 5, 5, 5],
        endOffsets: [337, 683, 765, 861, 965, 1089, 1194],
        locationTexts: [
          'firstName',
          'user.firstName',
          'user.getName',
          'user.getFirstName()',
          "user.getNewName('name')",
          'user.getNewName(name)',
          'lastName: user.firstName',
        ],
        messages: [
          'The argument has already been passed.',
          'The argument has already been passed.',
          'The argument has already been passed.',
          'The argument has already been passed.',
          'The argument has already been passed.',
          'The argument has already been passed.',
          'The argument has already been passed.',
        ],
      );
    });

    test('reports no issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = NoEqualArgumentsRule().check(unit);

      RuleTestHelper.verifyNoIssues(issues);
    });
  });

  test('reports about found issue with default config', () async {
    final unit =
        await RuleTestHelper.resolveFromFile(_namedParametersExamplePath);
    final issues = NoEqualArgumentsRule().check(unit);

    RuleTestHelper.verifyIssues(
      issues: issues,
      startOffsets: [201],
      startLines: [9],
      startColumns: [3],
      endOffsets: [220],
      locationTexts: ['lastName: firstName'],
      messages: ['The argument has already been passed.'],
    );
  });

  test('reports no issues with custom config', () async {
    final unit =
        await RuleTestHelper.resolveFromFile(_namedParametersExamplePath);
    final config = {
      'ignored-parameters': [
        'lastName',
      ],
    };

    final issues = NoEqualArgumentsRule(config).check(unit);

    RuleTestHelper.verifyNoIssues(issues);
  });
}
