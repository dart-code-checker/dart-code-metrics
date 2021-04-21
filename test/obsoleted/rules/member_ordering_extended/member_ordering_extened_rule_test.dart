@TestOn('vm')
import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:dart_code_metrics/src/models/severity.dart';
import 'package:dart_code_metrics/src/obsoleted/models/internal_resolved_unit_result.dart';
import 'package:dart_code_metrics/src/obsoleted/rules/member_ordering_extended/member_ordering_extended_rule.dart';
import 'package:test/test.dart';

const _examplePath =
    'test/obsoleted/rules/member_ordering_extended/examples/example.dart';
const _multipleClassesExamplePath =
    'test/obsoleted/rules/member_ordering_extended/examples/multiple_classes_example.dart';
const _alphabeticalExamplePath =
    'test/obsoleted/rules/member_ordering_extended/examples/alphabetical_example.dart';

void main() {
  group('MemberOrderingExtended', () {
    test('initialization', () async {
      final path = File(_examplePath).absolute.path;
      final sourceUrl = Uri.parse(path);

      // ignore: deprecated_member_use
      final parseResult = await resolveFile(path: path);

      final issues =
          MemberOrderingExtendedRule().check(InternalResolvedUnitResult(
        sourceUrl,
        parseResult!.content!,
        parseResult.unit!,
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

        final issues =
            MemberOrderingExtendedRule().check(InternalResolvedUnitResult(
          sourceUrl,
          parseResult!.content!,
          parseResult.unit!,
        ));

        expect(
          issues.map((issue) => issue.location.start.offset),
          equals([33, 72, 108, 134, 216, 358]),
        );
        expect(
          issues.map((issue) => issue.location.start.line),
          equals([4, 6, 8, 10, 16, 28]),
        );
        expect(
          issues.map((issue) => issue.location.start.column),
          equals([3, 3, 3, 3, 3, 3]),
        );
        expect(
          issues.map((issue) => issue.location.end.offset),
          equals([68, 104, 130, 165, 231, 385]),
        );
        expect(
          issues.map((issue) => issue.location.text),
          equals([
            "static const staticConstField = '';",
            'late final staticLateFinalField;',
            'String? nullableField;',
            'late String? lateNullableField;',
            'final data = 1;',
            'String get value => _value;',
          ]),
        );
        expect(
          issues.map((issue) => issue.message),
          equals([
            'public-fields should be before private-fields',
            'public-fields should be before private-fields',
            'public-fields should be before private-fields',
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

        final issues =
            MemberOrderingExtendedRule().check(InternalResolvedUnitResult(
          sourceUrl,
          parseResult!.content!,
          parseResult.unit!,
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

        final issues = MemberOrderingExtendedRule(config: config)
            .check(InternalResolvedUnitResult(
          sourceUrl,
          parseResult!.content!,
          parseResult.unit!,
        ));

        expect(
          issues.map((issue) => issue.location.start.offset),
          equals([235, 246, 281, 389]),
        );
        expect(
          issues.map((issue) => issue.location.start.line),
          equals([18, 20, 22, 30]),
        );
        expect(
          issues.map((issue) => issue.location.start.column),
          equals([3, 3, 3, 3]),
        );
        expect(
          issues.map((issue) => issue.location.end.offset),
          equals([242, 277, 295, 427]),
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

        final issues = MemberOrderingExtendedRule(config: config)
            .check(InternalResolvedUnitResult(
          sourceUrl,
          parseResult!.content!,
          parseResult.unit!,
        ));

        expect(
          issues.map((issue) => issue.location.start.offset),
          equals([216, 235, 246, 281, 358, 389]),
        );
        expect(
          issues.map((issue) => issue.location.start.line),
          equals([16, 18, 20, 22, 28, 30]),
        );
        expect(
          issues.map((issue) => issue.location.start.column),
          equals([3, 3, 3, 3, 3, 3]),
        );
        expect(
          issues.map((issue) => issue.location.end.offset),
          equals([231, 242, 277, 295, 385, 427]),
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

          final issues = MemberOrderingExtendedRule(config: config)
              .check(InternalResolvedUnitResult(
            sourceUrl,
            parseResult!.content!,
            parseResult.unit!,
          ));

          expect(
            issues.map((issue) => issue.location.start.offset),
            equals([216, 235, 281, 358, 389]),
          );
          expect(
            issues.map((issue) => issue.location.start.line),
            equals([16, 18, 22, 28, 30]),
          );
          expect(
            issues.map((issue) => issue.location.start.column),
            equals([3, 3, 3, 3, 3]),
          );
          expect(
            issues.map((issue) => issue.location.end.offset),
            equals([231, 242, 295, 385, 427]),
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
              'late-fields',
              'nullable-fields',
              'private-fields',
            ],
          };

          final issues = MemberOrderingExtendedRule(config: config)
              .check(InternalResolvedUnitResult(
            sourceUrl,
            parseResult!.content!,
            parseResult.unit!,
          ));

          expect(
            issues.map((issue) => issue.location.start.offset),
            equals([33, 134, 216]),
          );
          expect(
            issues.map((issue) => issue.location.start.line),
            equals([4, 10, 16]),
          );
          expect(
            issues.map((issue) => issue.location.start.column),
            equals([3, 3, 3]),
          );
          expect(
            issues.map((issue) => issue.location.end.offset),
            equals([68, 165, 231]),
          );
          expect(
            issues.map((issue) => issue.location.text),
            equals([
              "static const staticConstField = '';",
              'late String? lateNullableField;',
              'final data = 1;',
            ]),
          );
          expect(
            issues.map((issue) => issue.message),
            equals([
              'public-static-fields should be before private-fields',
              'late-fields should be before nullable-fields',
              'public-final-fields should be before late-fields',
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

        final issues = MemberOrderingExtendedRule(config: config)
            .check(InternalResolvedUnitResult(
          sourceUrl,
          parseResult!.content!,
          parseResult.unit!,
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
