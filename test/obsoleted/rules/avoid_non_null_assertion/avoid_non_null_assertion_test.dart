@TestOn('vm')
import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:dart_code_metrics/src/models/severity.dart';
import 'package:dart_code_metrics/src/obsoleted/models/internal_resolved_unit_result.dart';
import 'package:dart_code_metrics/src/obsoleted/rules/avoid_non_null_assertion_rule.dart';
import 'package:test/test.dart';

const _examplePath =
    'test/obsoleted/rules/avoid_non_null_assertion/examples/example.dart';

void main() {
  group('AvoidNonNullAssertion', () {
    test('initialization', () async {
      final path = File(_examplePath).absolute.path;
      final sourceUrl = Uri.parse(path);

      // ignore: deprecated_member_use
      final parseResult = await resolveFile(path: path);

      final issues =
          AvoidNonNullAssertionRule().check(InternalResolvedUnitResult(
        sourceUrl,
        parseResult!.content!,
        parseResult.unit!,
      ));

      expect(
        issues.every(
          (issue) => issue.ruleId == 'avoid-non-null-assertion',
        ),
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

      final issues =
          AvoidNonNullAssertionRule().check(InternalResolvedUnitResult(
        sourceUrl,
        parseResult!.content!,
        parseResult.unit!,
      ));

      expect(
        issues.map((issue) => issue.location.start.offset),
        equals([70, 208, 208, 460]),
      );
      expect(
        issues.map((issue) => issue.location.start.line),
        equals([7, 15, 15, 27]),
      );
      expect(
        issues.map((issue) => issue.location.start.column),
        equals([5, 5, 5, 5]),
      );
      expect(
        issues.map((issue) => issue.location.end.offset),
        equals([76, 215, 222, 467]),
      );
      expect(
        issues.map((issue) => issue.location.text),
        equals([
          'field!',
          'object!',
          'object!.field!',
          'object!',
        ]),
      );
      expect(
        issues.map((issue) => issue.message),
        equals([
          'Avoid using non null assertion.',
          'Avoid using non null assertion.',
          'Avoid using non null assertion.',
          'Avoid using non null assertion.',
        ]),
      );
    });
  });
}
