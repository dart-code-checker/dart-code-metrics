@TestOn('vm')
import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:code_checker/rules.dart';
import 'package:dart_code_metrics/src/rules/member_ordering_extended/member_ordering_extended_rule.dart';
import 'package:test/test.dart';

const _examplePath =
    'test/rules/member_ordering_extended/examples/example.dart';
const _multipleClassesExamplePath =
    'test/rules/member_ordering_extended/examples/multiple_classes_example.dart';
const _alphabeticalExamplePath =
    'test/rules/member_ordering_extended/examples/alphabetical_example.dart';

void main() {
  group('MemberOrderingExtended', () {
    test('initialization', () async {
      final path = File(_examplePath).absolute.path;
      final sourceUrl = Uri.parse(path);

      // ignore: deprecated_member_use
      final parseResult = await resolveFile(path: path);

      final issues = MemberOrderingExtendedRule().check(ProcessedFile(
        sourceUrl,
        parseResult.content,
        parseResult.unit,
      ));

      expect(
        issues.every((issue) => issue.ruleId == 'member-ordering-extended'),
        isTrue,
      );
      expect(
        issues.every((issue) => issue.severity == Severity.style),
        isTrue,
      );
    });

    group('with default config', () {
      test('reports about found issues', () async {
        final path = File(_examplePath).absolute.path;
        final sourceUrl = Uri.parse(path);

        // ignore: deprecated_member_use
        final parseResult = await resolveFile(path: path);

        final issues = MemberOrderingExtendedRule().check(ProcessedFile(
          sourceUrl,
          parseResult.content,
          parseResult.unit,
        ));

        expect(
          issues.map((issue) => issue.location.start.offset),
          equals([33, 119, 261]),
        );
        expect(
          issues.map((issue) => issue.location.start.line),
          equals([4, 10, 22]),
        );
        expect(
          issues.map((issue) => issue.location.start.column),
          equals([3, 3, 3]),
        );
        expect(
          issues.map((issue) => issue.location.end.offset),
          equals([68, 134, 288]),
        );
        expect(
          issues.map((issue) => issue.location.text),
          equals([
            "static const staticConstField = '';",
            'final data = 1;',
            'String get value => _value;',
          ]),
        );
        expect(
          issues.map((issue) => issue.message),
          equals([
            'public-fields should be before private-fields',
            'public-fields should be before public-methods',
            'public-getters should be before private-methods',
          ]),
        );
      });

      test('and multiple classes in a file reports no issues', () async {
        final path = File(_multipleClassesExamplePath).absolute.path;
        final sourceUrl = Uri.parse(path);

        // ignore: deprecated_member_use
        final parseResult = await resolveFile(path: path);

        final issues = MemberOrderingExtendedRule().check(ProcessedFile(
          sourceUrl,
          parseResult.content,
          parseResult.unit,
        ));

        expect(issues.isEmpty, isTrue);
      });
    });

    group('with custom config', () {
      test('reports about found issues', () async {
        final path = File(_examplePath).absolute.path;
        final sourceUrl = Uri.parse(path);

        // ignore: deprecated_member_use
        final parseResult = await resolveFile(path: path);

        final config = {
          'order': [
            'constructors',
            'public-setters',
            'private-methods',
            'public-fields',
          ],
        };

        final issues =
            MemberOrderingExtendedRule(config: config).check(ProcessedFile(
          sourceUrl,
          parseResult.content,
          parseResult.unit,
        ));

        expect(
          issues.map((issue) => issue.location.start.offset),
          equals([138, 149, 184, 292]),
        );
        expect(
          issues.map((issue) => issue.location.start.line),
          equals([12, 14, 16, 24]),
        );
        expect(
          issues.map((issue) => issue.location.start.column),
          equals([3, 3, 3, 3]),
        );
        expect(
          issues.map((issue) => issue.location.end.offset),
          equals([145, 180, 198, 330]),
        );
        expect(
          issues.map((issue) => issue.location.text),
          equals([
            'Test();',
            'factory Test.empty() => Test();',
            'Test.create();',
            'set value(String str) => _value = str;',
          ]),
        );
        expect(
          issues.map((issue) => issue.message),
          equals([
            'constructors should be before public-fields',
            'constructors should be before public-fields',
            'constructors should be before public-fields',
            'public-setters should be before private-methods',
          ]),
        );
      });

      test('accepts categories and reports about found issues', () async {
        final path = File(_examplePath).absolute.path;
        final sourceUrl = Uri.parse(path);

        // ignore: deprecated_member_use
        final parseResult = await resolveFile(path: path);

        final config = {
          'order': [
            'constructors',
            'fields',
            'getters-setters',
            'methods',
          ],
        };

        final issues =
            MemberOrderingExtendedRule(config: config).check(ProcessedFile(
          sourceUrl,
          parseResult.content,
          parseResult.unit,
        ));

        expect(
          issues.map((issue) => issue.location.start.offset),
          equals([119, 138, 149, 184, 261, 292]),
        );
        expect(
          issues.map((issue) => issue.location.start.line),
          equals([10, 12, 14, 16, 22, 24]),
        );
        expect(
          issues.map((issue) => issue.location.start.column),
          equals([3, 3, 3, 3, 3, 3]),
        );
        expect(
          issues.map((issue) => issue.location.end.offset),
          equals([134, 145, 180, 198, 288, 330]),
        );
        expect(
          issues.map((issue) => issue.location.text),
          equals([
            'final data = 1;',
            'Test();',
            'factory Test.empty() => Test();',
            'Test.create();',
            'String get value => _value;',
            'set value(String str) => _value = str;',
          ]),
        );
        expect(
          issues.map((issue) => issue.message),
          equals([
            'fields should be before methods',
            'constructors should be before fields',
            'constructors should be before fields',
            'constructors should be before fields',
            'getters-setters should be before methods',
            'getters-setters should be before methods',
          ]),
        );
      });

      test(
        'accepts decomposed constructor categories and reports about found issues',
        () async {
          final path = File(_examplePath).absolute.path;
          final sourceUrl = Uri.parse(path);

          // ignore: deprecated_member_use
          final parseResult = await resolveFile(path: path);

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

          final issues =
              MemberOrderingExtendedRule(config: config).check(ProcessedFile(
            sourceUrl,
            parseResult.content,
            parseResult.unit,
          ));

          expect(
            issues.map((issue) => issue.location.start.offset),
            equals([119, 138, 184, 261, 292]),
          );
          expect(
            issues.map((issue) => issue.location.start.line),
            equals([10, 12, 16, 22, 24]),
          );
          expect(
            issues.map((issue) => issue.location.start.column),
            equals([3, 3, 3, 3, 3]),
          );
          expect(
            issues.map((issue) => issue.location.end.offset),
            equals([134, 145, 198, 288, 330]),
          );
          expect(
            issues.map((issue) => issue.location.text),
            equals([
              'final data = 1;',
              'Test();',
              'Test.create();',
              'String get value => _value;',
              'set value(String str) => _value = str;',
            ]),
          );
          expect(
            issues.map((issue) => issue.message),
            equals([
              'fields should be before methods',
              'constructors should be before fields',
              'named-constructors should be before factory-constructors',
              'getters-setters should be before methods',
              'getters-setters should be before methods',
            ]),
          );
        },
      );

      test(
        'accepts decomposed fields categories and reports about found issues',
        () async {
          final path = File(_examplePath).absolute.path;
          final sourceUrl = Uri.parse(path);

          // ignore: deprecated_member_use
          final parseResult = await resolveFile(path: path);

          final config = {
            'order': [
              'public-static-fields',
              'private-static-fields',
              'public-final-fields',
              'private-final-fields',
              'private-fields',
            ],
          };

          final issues =
              MemberOrderingExtendedRule(config: config).check(ProcessedFile(
            sourceUrl,
            parseResult.content,
            parseResult.unit,
          ));

          expect(
            issues.map((issue) => issue.location.start.offset),
            equals([33]),
          );
          expect(
            issues.map((issue) => issue.location.start.line),
            equals([4]),
          );
          expect(
            issues.map((issue) => issue.location.start.column),
            equals([3]),
          );
          expect(
            issues.map((issue) => issue.location.end.offset),
            equals([68]),
          );
          expect(
            issues.map((issue) => issue.location.text),
            equals([
              "static const staticConstField = '';",
            ]),
          );
          expect(
            issues.map((issue) => issue.message),
            equals([
              'public-static-fields should be before private-fields',
            ]),
          );
        },
      );

      test('and alphabetical order reports about found issues', () async {
        final path = File(_alphabeticalExamplePath).absolute.path;
        final sourceUrl = Uri.parse(path);

        // ignore: deprecated_member_use
        final parseResult = await resolveFile(path: path);

        final config = {
          'alphabetize': true,
          'order': [
            'public-methods',
            'public-fields',
          ],
        };

        final issues =
            MemberOrderingExtendedRule(config: config).check(ProcessedFile(
          sourceUrl,
          parseResult.content,
          parseResult.unit,
        ));

        expect(
          issues.map((issue) => issue.location.start.offset),
          equals([78, 96, 116, 35, 54, 96]),
        );
        expect(
          issues.map((issue) => issue.location.start.line),
          equals([8, 10, 12, 4, 6, 10]),
        );
        expect(
          issues.map((issue) => issue.location.start.column),
          equals([3, 3, 3, 3, 3, 3]),
        );
        expect(
          issues.map((issue) => issue.location.end.offset),
          equals([92, 112, 130, 50, 74, 112]),
        );
        expect(
          issues.map((issue) => issue.location.text),
          equals([
            'void work() {}',
            'void create() {}',
            'void init() {}',
            'final data = 2;',
            'final algorithm = 3;',
            'void create() {}',
          ]),
        );
        expect(
          issues.map((issue) => issue.message),
          equals([
            'public-methods should be before public-fields',
            'public-methods should be before public-fields',
            'public-methods should be before public-fields',
            'data should be alphabetically before value',
            'algorithm should be alphabetically before data',
            'create should be alphabetically before work',
          ]),
        );
      });
    });
  });
}
