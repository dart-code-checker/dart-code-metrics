import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:code_checker/rules.dart';
import 'package:dart_code_metrics/src/obsoleted/models/internal_resolved_unit_result.dart';
import 'package:dart_code_metrics/src/obsoleted/rules/prefer_trailing_comma.dart';
import 'package:test/test.dart';

// ignore_for_file: avoid_escaping_inner_quotes, no_adjacent_strings_in_list

const correctExamplePath =
    'test/obsoleted/rules/prefer_trailing_comma/examples/correct_example.dart';
const incorrectExamplePath =
    'test/obsoleted/rules/prefer_trailing_comma/examples/incorrect_example.dart';

void main() {
  group('PreferTrailingComma', () {
    test('initialization', () async {
      final path = File(correctExamplePath).absolute.path;
      final sourceUrl = Uri.parse(path);

      final parseResult = await resolveFile(path: path);

      final issues = PreferTrailingComma().check(InternalResolvedUnitResult(
        sourceUrl,
        parseResult.content,
        parseResult.unit,
      ));

      expect(
        issues.every((issue) => issue.ruleId == 'prefer-trailing-comma'),
        isTrue,
      );
      expect(
        issues.every((issue) => issue.severity == Severity.warning),
        isTrue,
      );
    });

    test('with default config reports about found issues', () async {
      final path = File(incorrectExamplePath).absolute.path;
      final sourceUrl = Uri.parse(path);

      final parseResult = await resolveFile(path: path);

      final issues = PreferTrailingComma().check(InternalResolvedUnitResult(
        sourceUrl,
        parseResult.content,
        parseResult.unit,
      ));

      expect(
        issues.map((issue) => issue.location.start.offset),
        equals([69, 188, 317, 423, 548, 649, 763, 971, 1150, 1255, 1377]),
      );
      expect(
        issues.map((issue) => issue.location.start.line),
        equals([2, 8, 12, 16, 22, 26, 36, 46, 55, 61, 66]),
      );
      expect(
        issues.map((issue) => issue.location.start.column),
        equals([50, 7, 5, 52, 9, 8, 3, 59, 3, 3, 3]),
      );
      expect(
        issues.map((issue) => issue.location.end.offset),
        equals([89, 226, 328, 443, 586, 668, 772, 986, 1188, 1293, 1455]),
      );
      expect(
        issues.map((issue) => issue.location.text),
        equals([
          'String thirdArgument',
          "'and another string for length exceed'",
          'String arg3',
          'String thirdArgument',
          "'and another string for length exceed'",
          "'some other string'",
          'sixthItem',
          'this.forthField',
          "'and another string for length exceed'",
          "'and another string for length exceed'",
          "'and another string for length exceed': 'and another string for length exceed'",
        ]),
      );
      expect(
        issues.map((issue) => issue.message),
        equals([
          'Prefer trailing comma',
          'Prefer trailing comma',
          'Prefer trailing comma',
          'Prefer trailing comma',
          'Prefer trailing comma',
          'Prefer trailing comma',
          'Prefer trailing comma',
          'Prefer trailing comma',
          'Prefer trailing comma',
          'Prefer trailing comma',
          'Prefer trailing comma',
        ]),
      );

      expect(
        issues.map((issue) => issue.suggestion.comment),
        equals([
          'Add trailing comma',
          'Add trailing comma',
          'Add trailing comma',
          'Add trailing comma',
          'Add trailing comma',
          'Add trailing comma',
          'Add trailing comma',
          'Add trailing comma',
          'Add trailing comma',
          'Add trailing comma',
          'Add trailing comma',
        ]),
      );
      expect(
        issues.map((issue) => issue.suggestion.replacement),
        equals([
          'String thirdArgument,',
          "'and another string for length exceed',",
          'String arg3,',
          'String thirdArgument,',
          "'and another string for length exceed',",
          "'some other string',",
          'sixthItem,',
          'this.forthField,',
          "'and another string for length exceed',",
          "'and another string for length exceed',",
          "'and another string for length exceed': 'and another string for length exceed',",
        ]),
      );
    });

    test('with default config reports no issues', () async {
      final path = File(correctExamplePath).absolute.path;
      final sourceUrl = Uri.parse(path);

      final parseResult = await resolveFile(path: path);

      final issues = PreferTrailingComma().check(InternalResolvedUnitResult(
        sourceUrl,
        parseResult.content,
        parseResult.unit,
      ));

      expect(issues.isEmpty, isTrue);
    });

    test('with custom config reports about found issues', () async {
      final path = File(correctExamplePath).absolute.path;
      final sourceUrl = Uri.parse(path);

      final parseResult = await resolveFile(path: path);

      final issues = PreferTrailingComma(config: {'break_on': 1})
          .check(InternalResolvedUnitResult(
        sourceUrl,
        parseResult.content,
        parseResult.unit,
      ));

      expect(
        issues.map((issue) => issue.location.start.offset),
        equals([130, 226, 275, 610, 656, 1002, 1287, 1370, 1553, 1732]),
      );
      expect(
        issues.map((issue) => issue.location.start.line),
        equals([9, 17, 19, 37, 41, 75, 91, 99, 109, 119]),
      );
      expect(
        issues.map((issue) => issue.location.start.column),
        equals([21, 33, 20, 23, 19, 18, 43, 21, 19, 19]),
      );
      expect(
        issues.map((issue) => issue.location.end.offset),
        equals([141, 250, 299, 634, 680, 1011, 1288, 1383, 1566, 1760]),
      );
      expect(
        issues.map((issue) => issue.location.text),
        equals([
          'String arg1',
          'void Function() callback',
          'void Function() callback',
          '() {\n'
              '      return;\n'
              '    }',
          '() {\n'
              '      return;\n'
              '    }',
          'firstItem',
          '0',
          '\'some string\'',
          '\'some string\'',
          '\'some string\': \'some string\'',
        ]),
      );
      expect(
        issues.map((issue) => issue.message),
        equals([
          'Prefer trailing comma',
          'Prefer trailing comma',
          'Prefer trailing comma',
          'Prefer trailing comma',
          'Prefer trailing comma',
          'Prefer trailing comma',
          'Prefer trailing comma',
          'Prefer trailing comma',
          'Prefer trailing comma',
          'Prefer trailing comma',
        ]),
      );
    });
  });
}
