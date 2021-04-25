@TestOn('vm')
import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:dart_code_metrics/src/models/severity.dart';
import 'package:dart_code_metrics/src/obsoleted/models/internal_resolved_unit_result.dart';
import 'package:dart_code_metrics/src/obsoleted/rules/always_remove_listener_rule.dart';
import 'package:test/test.dart';

const _examplePath =
    'test/obsoleted/rules/always_remove_listener/examples/example.dart';

// TODO(incendial): migrate to the new testing approach

void main() {
  group('AlwaysRemoveListenerRule', () {
    test('initialization', () async {
      final path = File(_examplePath).absolute.path;
      final sourceUrl = Uri.parse(path);

      // ignore: deprecated_member_use
      final parseResult = await resolveFile(path: path);

      final issues =
          AlwaysRemoveListenerRule().check(InternalResolvedUnitResult(
        sourceUrl,
        parseResult!.content!,
        parseResult.unit!,
      ));

      expect(
        issues.every((issue) => issue.ruleId == 'always-remove-listener'),
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
          AlwaysRemoveListenerRule().check(InternalResolvedUnitResult(
        sourceUrl,
        parseResult!.content!,
        parseResult.unit!,
      ));

      expect(
        issues.map((issue) => issue.location.start.offset),
        equals([433, 485, 581, 726, 918, 977]),
      );
      expect(
        issues.map((issue) => issue.location.start.line),
        equals([21, 22, 25, 30, 38, 40]),
      );
      expect(
        issues.map((issue) => issue.location.start.column),
        equals([5, 5, 5, 7, 5, 5]),
      );
      expect(
        issues.map((issue) => issue.location.end.offset),
        equals([471, 521, 622, 746, 962, 1012]),
      );
      expect(
        issues.map((issue) => issue.location.text),
        equals([
          '_anotherListener.addListener(listener)',
          '_thirdListener.addListener(listener)',
          'widget.someListener.addListener(listener)',
          '..addListener(() {})',
          'widget.anotherListener.addListener(listener)',
          '_someListener.addListener(listener)',
        ]),
      );
      expect(
        issues.map((issue) => issue.message),
        equals([
          'Listener is not removed. This might lead to a memory leak.',
          'Listener is not removed. This might lead to a memory leak.',
          'Listener is not removed. This might lead to a memory leak.',
          'Listener is not removed. This might lead to a memory leak.',
          'Listener is not removed. This might lead to a memory leak.',
          'Listener is not removed. This might lead to a memory leak.',
        ]),
      );
    });
  });
}
