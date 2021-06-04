@TestOn('vm')
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/member_ordering/member_ordering.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _examplePath = 'member_ordering/examples/example.dart';
const _multipleClassesExamplePath =
    'member_ordering/examples/multiple_classes_example.dart';
const _angularExamplePath = 'member_ordering/examples/angular_example.dart';
const _alphabeticalExamplePath =
    'member_ordering/examples/alphabetical_example.dart';

void main() {
  group('MemberOrderingRule', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = MemberOrderingRule().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'member-ordering',
        severity: Severity.style,
      );
    });
    group('with default config', () {
      test('reports about found issues', () async {
        final unit = await RuleTestHelper.resolveFromFile(_examplePath);
        final issues = MemberOrderingRule().check(unit);

        RuleTestHelper.verifyIssues(
          issues: issues,
          startOffsets: [80, 177],
          startLines: [8, 16],
          startColumns: [3, 3],
          endOffsets: [95, 204],
          locationTexts: [
            'final data = 1;',
            'String get value => _value;',
          ],
          messages: [
            'public-fields should be before public-methods.',
            'public-getters should be before private-methods.',
          ],
        );
      });

      test('and multiple classes reports no issues', () async {
        final unit =
            await RuleTestHelper.resolveFromFile(_multipleClassesExamplePath);
        final issues = MemberOrderingRule().check(unit);

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

        final issues = MemberOrderingRule(config).check(unit);

        RuleTestHelper.verifyIssues(
          issues: issues,
          startOffsets: [107, 216],
          startLines: [10, 18],
          startColumns: [3, 3],
          endOffsets: [114, 254],
          locationTexts: [
            'Test();',
            'set value(String str) => _value = str;',
          ],
          messages: [
            'constructors should be before public-fields.',
            'public-setters should be before private-methods.',
          ],
        );
      });

      test('for angular decorators reports about found issues', () async {
        final unit = await RuleTestHelper.resolveFromFile(_angularExamplePath);
        final config = {
          'order': [
            'angular-outputs',
            'angular-inputs',
            'angular-host-listeners',
            'angular-host-bindings',
            'angular-content-children',
            'angular-view-children',
            'constructors',
          ],
        };

        final issues = MemberOrderingRule(config).check(unit);

        RuleTestHelper.verifyIssues(
          issues: issues,
          startOffsets: [26, 68, 121, 169, 231, 267, 364],
          startLines: [4, 7, 10, 13, 16, 19, 25],
          startColumns: [3, 3, 3, 3, 3, 3, 3],
          endOffsets: [56, 109, 157, 219, 255, 310, 406],
          locationTexts: [
            "@ViewChild('')\n"
                '  Element view;',
            "@ViewChild('')\n"
                '  Iterable<Element> views;',
            "@ContentChild('')\n"
                '  Element content;',
            "@ContentChildren('')\n"
                '  Iterable<Element> contents;',
            '@Input()\n'
                '  String input;',
            '@Output()\n'
                '  Stream<void> get click => null;',
            "@HostListener('')\n"
                '  void handle() => null;',
          ],
          messages: [
            'angular-view-children should be before constructors.',
            'angular-view-children should be before constructors.',
            'angular-content-children should be before angular-view-children.',
            'angular-content-children should be before angular-view-children.',
            'angular-inputs should be before angular-content-children.',
            'angular-outputs should be before angular-inputs.',
            'angular-host-listeners should be before angular-host-bindings.',
          ],
        );
      });

      test('for alphabetical order reports about found issues', () async {
        final unit =
            await RuleTestHelper.resolveFromFile(_alphabeticalExamplePath);
        final config = {
          'alphabetize': true,
          'order': [
            'public-methods',
            'public-fields',
            'angular-inputs',
          ],
        };

        final issues = MemberOrderingRule(config).check(unit);

        RuleTestHelper.verifyIssues(
          issues: issues,
          startOffsets: [94, 120, 148, 35, 62, 120, 201],
          startLines: [8, 10, 12, 4, 6, 10, 17],
          startColumns: [3, 3, 3, 3, 3, 3, 3],
          endOffsets: [108, 136, 162, 50, 82, 136, 233],
          locationTexts: [
            'void work() {}',
            'void create() {}',
            'void init() {}',
            'final data = 2;',
            'final algorithm = 3;',
            'void create() {}',
            '@Input() // LINT\n'
                '  String first;',
          ],
          messages: [
            'public-methods should be before public-fields.',
            'public-methods should be before public-fields.',
            'public-methods should be before public-fields.',
            'data should be alphabetically before value.',
            'algorithm should be alphabetically before data.',
            'create should be alphabetically before work.',
            'first should be alphabetically before last.',
          ],
        );
      });
    });
  });
}
