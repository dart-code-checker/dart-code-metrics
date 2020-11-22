@TestOn('vm')

import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:dart_code_metrics/src/models/code_issue_severity.dart';
import 'package:dart_code_metrics/src/models/source.dart';
import 'package:dart_code_metrics/src/rules/prefer_entry_point_imports.dart';
import 'package:test/test.dart';

// ignore_for_file: no_adjacent_strings_in_list

const examplePath =
    'test/rules/prefer_entry_point_imports/examples/example.dart';

void main() {
  group('PreferEntryPointImports', () {
    test('initialization', () async {
      final path = File(examplePath).absolute.path;
      final sourceUrl = Uri.parse(path);

      final parseResult = await resolveFile(path: path);

      final issues = PreferEntryPointImports().check(Source(
        sourceUrl,
        parseResult.content,
        parseResult.unit,
      ));

      expect(
        issues.every((issue) => issue.ruleId == 'prefer-entry-point-imports'),
        isTrue,
      );
      expect(
        issues.every((issue) => issue.severity == CodeIssueSeverity.warning),
        isTrue,
      );
    });

    test('reports about found issues', () async {
      final path = File(examplePath).absolute.path;
      final sourceUrl = Uri.parse(path);

      final parseResult = await resolveFile(path: path);

      final issues = PreferEntryPointImports().check(Source(
        sourceUrl,
        parseResult.content,
        parseResult.unit,
      ));

      expect(
        issues.map((issue) => issue.sourceSpan.start.offset),
        equals([18, 96]),
      );
      expect(
        issues.map((issue) => issue.sourceSpan.start.line),
        equals([2, 3]),
      );
      expect(
        issues.map((issue) => issue.sourceSpan.start.column),
        equals([1, 1]),
      );
      expect(
        issues.map((issue) => issue.sourceSpan.end.offset),
        equals([95, 163]),
      );
      expect(
        issues.map((issue) => issue.sourceSpan.text),
        equals([
          "import 'package:dart_code_metrics/src/rules/prefer_entry_point_imports.dart';",
          "import '../../../../lib/src/rules/prefer_entry_point_imports.dart';",
        ]),
      );
      expect(
        issues.map((issue) => issue.message),
        equals([
          'Prefer entry point import instead of implementation import',
          'Prefer entry point import instead of implementation import',
        ]),
      );
    });
  });
}
