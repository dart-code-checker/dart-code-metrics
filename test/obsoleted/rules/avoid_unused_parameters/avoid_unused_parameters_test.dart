import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:code_checker/rules.dart';
import 'package:dart_code_metrics/src/obsoleted/models/internal_resolved_unit_result.dart';
import 'package:dart_code_metrics/src/obsoleted/rules/avoid_unused_parameters.dart';
import 'package:test/test.dart';

const correctExamplePath =
    'test/obsoleted/rules/avoid_unused_parameters/examples/correct_example.dart';
const incorrectExamplePath =
    'test/obsoleted/rules/avoid_unused_parameters/examples/incorrect_example.dart';

void main() {
  group('AvoidUnusedParameters', () {
    test('initialization', () async {
      final path = File(correctExamplePath).absolute.path;
      final sourceUrl = Uri.parse(path);

      final parseResult = await resolveFile(path: path);

      final issues = AvoidUnusedParameters().check(InternalResolvedUnitResult(
        sourceUrl,
        parseResult.content,
        parseResult.unit,
      ));

      expect(
        issues.every((issue) => issue.ruleId == 'avoid-unused-parameters'),
        isTrue,
      );
      expect(
        issues.every((issue) => issue.severity == Severity.warning),
        isTrue,
      );
    });

    test('reports no issues', () async {
      final path = File(correctExamplePath).absolute.path;
      final sourceUrl = Uri.parse(path);

      final parseResult = await resolveFile(path: path);

      final issues = AvoidUnusedParameters().check(InternalResolvedUnitResult(
        sourceUrl,
        parseResult.content,
        parseResult.unit,
      ));

      expect(issues.isEmpty, isTrue);
    });

    test('reports about found issues', () async {
      final path = File(incorrectExamplePath).absolute.path;
      final sourceUrl = Uri.parse(path);

      final parseResult = await resolveFile(path: path);

      final issues = AvoidUnusedParameters().check(InternalResolvedUnitResult(
        sourceUrl,
        parseResult.content,
        parseResult.unit,
      ));

      expect(
        issues.map((issue) => issue.location.start.offset),
        equals([132, 190, 341, 379, 607, 493, 677, 94]),
      );
      expect(
        issues.map((issue) => issue.location.start.line),
        equals([7, 9, 18, 20, 29, 24, 34, 5]),
      );
      expect(
        issues.map((issue) => issue.location.start.column),
        equals([20, 40, 20, 20, 28, 38, 20, 23]),
      );
      expect(
        issues.map((issue) => issue.location.end.offset),
        equals([145, 209, 354, 397, 623, 506, 693, 107]),
      );
      expect(
        issues.map((issue) => issue.location.text),
        equals([
          'String string',
          'String secondString',
          'String string',
          'String firstString',
          'TestClass object',
          'String string',
          'TestClass object',
          'String string',
        ]),
      );
      expect(
        issues.map((issue) => issue.message),
        equals([
          'Parameter is unused',
          'Parameter is unused',
          'Parameter is unused',
          'Parameter is unused',
          'Parameter is unused',
          'Parameter is unused',
          'Parameter is unused',
          'Parameter is unused, consider renaming it to _, __, etc.',
        ]),
      );
    });
  });
}
