import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:dart_code_metrics/src/models/code_issue_severity.dart';
import 'package:dart_code_metrics/src/models/source.dart';
import 'package:dart_code_metrics/src/rules/prefer_trailing_comma.dart';
import 'package:test/test.dart';

const examplePath = 'test/rules/prefer_trailing_comma/examples/example.dart';

void main() {
  group('PreferTrailingComma', () {
    test('initialization', () async {
      final path = File(examplePath).absolute.path;
      final sourceUrl = Uri.parse(path);

      final parseResult = await resolveFile(path: path);

      final issues = PreferTrailingComma().check(Source(
        sourceUrl,
        parseResult.content,
        parseResult.unit,
      ));

      expect(
        issues.every((issue) => issue.ruleId == 'prefer-trailing-comma'),
        isTrue,
      );
      expect(
        issues.every((issue) => issue.severity == CodeIssueSeverity.warning),
        isTrue,
      );
    });

    test('with default config reports about found issues', () async {
      final path = File(examplePath).absolute.path;
      final sourceUrl = Uri.parse(path);

      final parseResult = await resolveFile(path: path);

      final issues = PreferTrailingComma().check(Source(
        sourceUrl,
        parseResult.content,
        parseResult.unit,
      ));

      expect(
        issues.map((issue) => issue.sourceSpan.start.offset),
        equals([69, 262, 461, 705, 1000, 1272, 1435, 1615, 1825]),
      );
      expect(
        issues.map((issue) => issue.sourceSpan.start.line),
        equals([2, 12, 21, 33, 58, 74, 83, 93, 102]),
      );
      expect(
        issues.map((issue) => issue.sourceSpan.start.column),
        equals([50, 7, 52, 9, 3, 59, 3, 3, 3]),
      );
      expect(
        issues.map((issue) => issue.sourceSpan.end.offset),
        equals([89, 300, 481, 743, 1009, 1287, 1473, 1653, 1903]),
      );
      expect(
        issues.map((issue) => issue.sourceSpan.text),
        equals([
          'String thirdArgument',
          "'and another string for length exceed'",
          'String thirdArgument',
          "'and another string for length exceed'",
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
        ]),
      );

      expect(
        issues.map((issue) => issue.correctionComment),
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
        ]),
      );
      expect(
        issues.map((issue) => issue.correction),
        equals([
          'String thirdArgument,',
          "'and another string for length exceed',",
          'String thirdArgument,',
          "'and another string for length exceed',",
          'sixthItem,',
          'this.forthField,',
          "'and another string for length exceed',",
          "'and another string for length exceed',",
          "'and another string for length exceed': 'and another string for length exceed',",
        ]),
      );
    });

    test('with custom config reports about found issues', () async {
      final path = File(examplePath).absolute.path;
      final sourceUrl = Uri.parse(path);

      final parseResult = await resolveFile(path: path);

      final issues = PreferTrailingComma(config: {'break_on': 2}).check(Source(
        sourceUrl,
        parseResult.content,
        parseResult.unit,
      ));

      expect(
        issues.map((issue) => issue.sourceSpan.start.offset),
        equals([69, 262, 364, 461, 705, 1000, 1272, 1330, 1435, 1615, 1825]),
      );
      expect(
        issues.map((issue) => issue.sourceSpan.start.line),
        equals([2, 12, 16, 21, 33, 58, 74, 77, 83, 93, 102]),
      );
      expect(
        issues.map((issue) => issue.sourceSpan.start.column),
        equals([50, 7, 25, 52, 9, 3, 59, 38, 3, 3, 3]),
      );
      expect(
        issues.map((issue) => issue.sourceSpan.end.offset),
        equals([89, 300, 366, 481, 743, 1009, 1287, 1331, 1473, 1653, 1903]),
      );
      expect(
        issues.map((issue) => issue.sourceSpan.text),
        equals([
          'String thirdArgument',
          "'and another string for length exceed'",
          "''",
          'String thirdArgument',
          "'and another string for length exceed'",
          'sixthItem',
          'this.forthField',
          '0',
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
    });
  });
}
