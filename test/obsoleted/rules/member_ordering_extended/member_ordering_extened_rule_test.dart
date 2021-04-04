@TestOn('vm')

import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:dart_code_metrics/src/models/severity.dart';
import 'package:dart_code_metrics/src/obsoleted/models/internal_resolved_unit_result.dart';
import 'package:dart_code_metrics/src/obsoleted/rules/member_ordering_extended/member_ordering_extended_rule.dart';
import 'package:test/test.dart';

// ignore_for_file: no_adjacent_strings_in_list

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

        final parseResult = await resolveFile(path: path);

        final issues =
            MemberOrderingExtendedRule().check(InternalResolvedUnitResult(
          sourceUrl,
          parseResult!.content!,
          parseResult.unit!,
        ));

        expect(
          issues.map((issue) => issue.location.start.offset),
          equals([33, 72, 108, 134, 221, 365]),
        );
        expect(
          issues.map((issue) => issue.location.start.line),
          equals([4, 6, 8, 10, 20, 34]),
        );
        expect(
          issues.map((issue) => issue.location.start.column),
          equals([3, 3, 3, 3, 3, 3]),
        );
        expect(
          issues.map((issue) => issue.location.end.offset),
          equals([68, 104, 130, 165, 236, 392]),
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
            'public_fields should be before private_fields',
            'public_fields should be before private_fields',
            'public_fields should be before private_fields',
            'public_fields should be before private_fields',
            'public_fields should be before public_methods',
            'public_getters should be before private_methods',
          ]),
        );
      });

      test('and multiple classes in a file reports no issues', () async {
        final path = File(_multipleClassesExamplePath).absolute.path;
        final sourceUrl = Uri.parse(path);

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

        final parseResult = await resolveFile(path: path);

        final config = {
          'order': [
            'constructors',
            'public_setters',
            'private_methods',
            'public_fields',
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
          equals([240, 251, 286, 396]),
        );
        expect(
          issues.map((issue) => issue.location.start.line),
          equals([22, 24, 26, 36]),
        );
        expect(
          issues.map((issue) => issue.location.start.column),
          equals([3, 3, 3, 3]),
        );
        expect(
          issues.map((issue) => issue.location.end.offset),
          equals([247, 282, 300, 434]),
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
            'constructors should be before public_fields',
            'constructors should be before public_fields',
            'constructors should be before public_fields',
            'public_setters should be before private_methods',
          ]),
        );
      });

      test('accepts categories and reports about found issues', () async {
        final path = File(_examplePath).absolute.path;
        final sourceUrl = Uri.parse(path);

        final parseResult = await resolveFile(path: path);

        final config = {
          'order': [
            'constructors',
            'fields',
            'getters_setters',
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
          equals([221, 240, 251, 286, 396]),
        );
        expect(
          issues.map((issue) => issue.location.start.line),
          equals([20, 22, 24, 26, 36]),
        );
        expect(
          issues.map((issue) => issue.location.start.column),
          equals([3, 3, 3, 3, 3]),
        );
        expect(
          issues.map((issue) => issue.location.end.offset),
          equals([236, 247, 282, 300, 434]),
        );
        expect(
          issues.map((issue) => issue.location.text),
          equals([
            'final data = 1;',
            'Test();',
            'factory Test.empty() => Test();',
            'Test.create();',
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
            'getters_setters should be before methods',
          ]),
        );
      });

      test(
        'accepts decomposed constructor categories and reports about found issues',
        () async {
          final path = File(_examplePath).absolute.path;
          final sourceUrl = Uri.parse(path);

          final parseResult = await resolveFile(path: path);

          final config = {
            'order': [
              'constructors',
              'fields',
              'getters_setters',
              'named_constructors',
              'factory_constructors',
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
            equals([221, 240, 286, 396]),
          );
          expect(
            issues.map((issue) => issue.location.start.line),
            equals([20, 22, 26, 36]),
          );
          expect(
            issues.map((issue) => issue.location.start.column),
            equals([3, 3, 3, 3]),
          );
          expect(
            issues.map((issue) => issue.location.end.offset),
            equals([236, 247, 300, 434]),
          );
          expect(
            issues.map((issue) => issue.location.text),
            equals([
              'final data = 1;',
              'Test();',
              'Test.create();',
              'set value(String str) => _value = str;',
            ]),
          );
          expect(
            issues.map((issue) => issue.message),
            equals([
              'fields should be before methods',
              'constructors should be before fields',
              'named_constructors should be before factory_constructors',
              'getters_setters should be before methods',
            ]),
          );
        },
      );

      test(
        'accepts decomposed fields categories and reports about found issues',
        () async {
          final path = File(_examplePath).absolute.path;
          final sourceUrl = Uri.parse(path);

          final parseResult = await resolveFile(path: path);

          final config = {
            'order': [
              'public_static_fields',
              'private_static_fields',
              'public_final_fields',
              'private_final_fields',
              'late_fields',
              'nullable_fields',
              'private_fields',
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
            equals([33, 134, 221]),
          );
          expect(
            issues.map((issue) => issue.location.start.line),
            equals([4, 10, 20]),
          );
          expect(
            issues.map((issue) => issue.location.start.column),
            equals([3, 3, 3]),
          );
          expect(
            issues.map((issue) => issue.location.end.offset),
            equals([68, 165, 236]),
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
              'public_static_fields should be before private_fields',
              'late_fields should be before nullable_fields',
              'public_final_fields should be before late_fields',
            ]),
          );
        },
      );

      test('and alphabetical order reports about found issues', () async {
        final path = File(_alphabeticalExamplePath).absolute.path;
        final sourceUrl = Uri.parse(path);

        final parseResult = await resolveFile(path: path);

        final config = {
          'alphabetize': true,
          'order': [
            'public_methods',
            'public_fields',
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
            'public_methods should be before public_fields',
            'public_methods should be before public_fields',
            'public_methods should be before public_fields',
            'data should be alphabetically before value',
            'algorithm should be alphabetically before data',
            'create should be alphabetically before work',
          ]),
        );
      });
    });
  });
}
