@TestOn('vm')
import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:dart_code_metrics/src/models/severity.dart';
import 'package:dart_code_metrics/src/obsoleted/models/internal_resolved_unit_result.dart';
import 'package:dart_code_metrics/src/obsoleted/rules/avoid_late_keyword.dart';
import 'package:test/test.dart';

const _examplePath =
    'test/obsoleted/rules/avoid_late_keyword/examples/example.dart';

void main() {
  group('AvoidLateKeyword', () {
    test('initialization', () async {
      final path = File(_examplePath).absolute.path;
      final sourceUrl = Uri.parse(path);

      // ignore: deprecated_member_use
      final parseResult = await resolveFile(path: path);

      final issues = AvoidLateKeywordRule().check(InternalResolvedUnitResult(
        sourceUrl,
        parseResult!.content!,
        parseResult.unit!,
      ));

      expect(
        issues.every((issue) => issue.ruleId == 'avoid-late-keyword'),
        isTrue,
      );
      expect(
        issues.every((issue) => issue.severity == Severity.warning),
        isTrue,
      );
    });

    test('reports about found issues', () async {
      final path = File(_examplePath).absolute.path;
      final sourceUrl = Uri.parse(path);

      // ignore: deprecated_member_use
      final parseResult = await resolveFile(path: path);

      final issues = AvoidLateKeywordRule().check(InternalResolvedUnitResult(
        sourceUrl,
        parseResult!.content!,
        parseResult.unit!,
      ));

      expect(
        issues.map((issue) => issue.location.start.offset),
        equals([15, 116, 179, 288, 338, 387]),
      );
      expect(
        issues.map((issue) => issue.location.start.line),
        equals([2, 8, 11, 17, 21, 23]),
      );
      expect(
        issues.map((issue) => issue.location.start.column),
        equals([3, 3, 5, 5, 1, 1]),
      );
      expect(
        issues.map((issue) => issue.location.end.offset),
        equals([42, 146, 209, 321, 376, 428]),
      );
      expect(
        issues.map((issue) => issue.location.text),
        equals([
          "late final field = 'string'",
          'late String uninitializedField',
          "late final variable = 'string'",
          'late String uninitializedVariable',
          "late final topLevelVariable = 'string'",
          'late String topLevelUninitializedVariable'
        ]),
      );
      expect(
        issues.map((issue) => issue.message),
        equals([
          "Avoid using 'late' keyword.",
          "Avoid using 'late' keyword.",
          "Avoid using 'late' keyword.",
          "Avoid using 'late' keyword.",
          "Avoid using 'late' keyword.",
          "Avoid using 'late' keyword.",
        ]),
      );
    });
  });
}
