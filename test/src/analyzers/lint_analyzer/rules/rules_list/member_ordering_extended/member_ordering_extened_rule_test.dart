import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/member_ordering_extended/member_ordering_extended_rule.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _examplePath = 'member_ordering_extended/examples/example.dart';
const _multipleClassesExamplePath =
    'member_ordering_extended/examples/multiple_classes_example.dart';
const _alphabeticalExamplePath =
    'member_ordering_extended/examples/alphabetical_example.dart';
const _alphabeticalCorrectExamplePath =
    'member_ordering_extended/examples/alphabetical_correct_example.dart';
const _typeAlphabeticalExamplePath =
    'member_ordering_extended/examples/type_alphabetical_example.dart';

void main() {
  group('MemberOrderingExtendedRule', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = MemberOrderingExtendedRule().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'member-ordering-extended',
        severity: Severity.style,
      );
    });

    group('with default config', () {
      test('reports about found issues', () async {
        final unit = await RuleTestHelper.resolveFromFile(_examplePath);
        final issues = MemberOrderingExtendedRule().check(unit);

        RuleTestHelper.verifyIssues(
          issues: issues,
          startLines: [4, 6, 8, 10, 16, 28],
          startColumns: [3, 3, 3, 3, 3, 3],
          locationTexts: [
            "static const staticConstField = '';",
            'late final staticLateFinalField;',
            'String? nullableField;',
            'late String? lateNullableField;',
            'final data = 1;',
            'String get value => _value;',
          ],
          messages: [
            'public-fields should be before private-fields.',
            'public-fields should be before private-fields.',
            'public-fields should be before private-fields.',
            'public-fields should be before private-fields.',
            'public-fields should be before public-methods.',
            'public-getters should be before private-methods.',
          ],
        );
      });

      test('and multiple classes in a file reports no issues', () async {
        final unit =
            await RuleTestHelper.resolveFromFile(_multipleClassesExamplePath);
        final issues = MemberOrderingExtendedRule().check(unit);

        RuleTestHelper.verifyNoIssues(issues);
      });
    });

    group('with custom config', () {
      test('reports about found issues', () async {
        final unit = await RuleTestHelper.resolveFromFile(_examplePath);
        final config = {
          'order': [
            'constructors',
            'public-setters',
            'private-methods',
            'public-fields',
          ],
        };

        final issues = MemberOrderingExtendedRule(config).check(unit);

        RuleTestHelper.verifyIssues(
          issues: issues,
          startLines: [18, 20, 22, 30],
          startColumns: [3, 3, 3, 3],
          locationTexts: [
            'Test();',
            'factory Test.empty() => Test();',
            'Test.create();',
            'set value(String str) => _value = str;',
          ],
          messages: [
            'constructors should be before public-fields.',
            'constructors should be before public-fields.',
            'constructors should be before public-fields.',
            'public-setters should be before private-methods.',
          ],
        );
      });

      test('accepts categories and reports about found issues', () async {
        final unit = await RuleTestHelper.resolveFromFile(_examplePath);
        final config = {
          'order': [
            'constructors',
            'fields',
            'getters-setters',
            'methods',
          ],
        };

        final issues = MemberOrderingExtendedRule(config).check(unit);

        RuleTestHelper.verifyIssues(
          issues: issues,
          startLines: [16, 18, 20, 22, 28, 30],
          startColumns: [3, 3, 3, 3, 3, 3],
          locationTexts: [
            'final data = 1;',
            'Test();',
            'factory Test.empty() => Test();',
            'Test.create();',
            'String get value => _value;',
            'set value(String str) => _value = str;',
          ],
          messages: [
            'fields should be before methods.',
            'constructors should be before fields.',
            'constructors should be before fields.',
            'constructors should be before fields.',
            'getters-setters should be before methods.',
            'getters-setters should be before methods.',
          ],
        );
      });

      test(
        'accepts decomposed constructor categories and reports about found issues',
        () async {
          final unit = await RuleTestHelper.resolveFromFile(_examplePath);
          final config = {
            'order': [
              'constructors',
              'fields',
              'getters-setters',
              'named-constructors',
              'factory-constructors',
              'methods',
            ],
          };

          final issues = MemberOrderingExtendedRule(config).check(unit);

          RuleTestHelper.verifyIssues(
            issues: issues,
            startLines: [16, 18, 22, 28, 30],
            startColumns: [3, 3, 3, 3, 3],
            locationTexts: [
              'final data = 1;',
              'Test();',
              'Test.create();',
              'String get value => _value;',
              'set value(String str) => _value = str;',
            ],
            messages: [
              'fields should be before methods.',
              'constructors should be before fields.',
              'named-constructors should be before factory-constructors.',
              'getters-setters should be before methods.',
              'getters-setters should be before methods.',
            ],
          );
        },
      );

      test(
        'accepts decomposed fields categories and reports about found issues',
        () async {
          final unit = await RuleTestHelper.resolveFromFile(_examplePath);
          final config = {
            'order': [
              'public-static-fields',
              'private-static-fields',
              'public-final-fields',
              'private-final-fields',
              'late-fields',
              'nullable-fields',
              'private-fields',
            ],
          };

          final issues = MemberOrderingExtendedRule(config).check(unit);

          RuleTestHelper.verifyIssues(
            issues: issues,
            startLines: [4, 10, 16],
            startColumns: [3, 3, 3],
            locationTexts: [
              "static const staticConstField = '';",
              'late String? lateNullableField;',
              'final data = 1;',
            ],
            messages: [
              'public-static-fields should be before private-fields.',
              'late-fields should be before nullable-fields.',
              'public-final-fields should be before late-fields.',
            ],
          );
        },
      );

      group('and alphabetical order', () {
        test('reports about found issues', () async {
          final unit =
              await RuleTestHelper.resolveFromFile(_alphabeticalExamplePath);
          final config = {
            'alphabetize': true,
            'order': [
              'public-methods',
              'public-fields',
            ],
          };

          final issues = MemberOrderingExtendedRule(config).check(unit);

          RuleTestHelper.verifyIssues(
            issues: issues,
            startLines: [8, 10, 12, 4, 6, 10],
            startColumns: [3, 3, 3, 3, 3, 3],
            locationTexts: [
              'void work() {}',
              'void create() {}',
              'void init() {}',
              'final data = 2;',
              'final algorithm = 3;',
              'void create() {}',
            ],
            messages: [
              'public-methods should be before public-fields.',
              'public-methods should be before public-fields.',
              'public-methods should be before public-fields.',
              'data should be alphabetically before value.',
              'algorithm should be alphabetically before data.',
              'create should be alphabetically before work.',
            ],
          );
        });

        test('reports no issues', () async {
          final unit = await RuleTestHelper.resolveFromFile(
            _alphabeticalCorrectExamplePath,
          );
          final config = {
            'alphabetize': true,
            'order': [
              'public-fields',
              'public-getters-setters',
              'private-fields',
              'private-getters-setters',
            ],
          };

          final issues = MemberOrderingExtendedRule(config).check(unit);

          RuleTestHelper.verifyNoIssues(issues);
        });
      });

      group('and type alphabetical order', () {
        test('reports about found issues', () async {
          final unit = await RuleTestHelper.resolveFromFile(
            _typeAlphabeticalExamplePath,
          );
          final config = {
            'alphabetize-by-type': true,
            'order': [
              'public-methods',
              'public-fields',
            ],
          };

          final issues = MemberOrderingExtendedRule(config).check(unit);

          RuleTestHelper.verifyIssues(
            issues: issues,
            startLines: [15, 19, 21, 8, 19],
            startColumns: [3, 3, 3, 3, 3],
            locationTexts: [
              'String work() {\n'
                  "    return '';\n"
                  '  }',
              'bool create() => false;',
              'void init() {}',
              'double f;',
              'bool create() => false;',
            ],
            messages: [
              'public-methods should be before public-fields.',
              'public-methods should be before public-fields.',
              'public-methods should be before public-fields.',
              'f type name should be alphabetically before z.',
              'create type name should be alphabetically before work.',
            ],
          );
        });
      });
    });
  });
}
