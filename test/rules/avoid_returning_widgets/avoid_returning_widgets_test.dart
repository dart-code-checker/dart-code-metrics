@TestOn('vm')
import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:code_checker/rules.dart';
import 'package:dart_code_metrics/src/rules/avoid_returning_widgets_rule.dart';
import 'package:test/test.dart';

// ignore_for_file: no_adjacent_strings_in_list

const _examplePath = 'test/rules/avoid_returning_widgets/examples/example.dart';

void main() {
  group('AvoidReturningWidgets', () {
    test('initialization', () async {
      final path = File(_examplePath).absolute.path;
      final sourceUrl = Uri.parse(path);

      // ignore: deprecated_member_use
      final parseResult = await resolveFile(path: path);

      final issues = AvoidReturningWidgets().check(
        ProcessedFile(sourceUrl, parseResult.content, parseResult.unit),
      );

      expect(
        issues.every(
          (issue) => issue.ruleId == 'avoid-returning-widgets',
        ),
        isTrue,
      );
      expect(
        issues.every((issue) => issue.severity == Severity.warning),
        isTrue,
      );
    });

    test('reports about found issues with the default config', () async {
      final path = File(_examplePath).absolute.path;
      final sourceUrl = Uri.parse(path);

      // ignore: deprecated_member_use
      final parseResult = await resolveFile(path: path);

      final issues = AvoidReturningWidgets().check(
        ProcessedFile(sourceUrl, parseResult.content, parseResult.unit),
      );

      expect(
        issues.map((issue) => issue.location.start.offset),
        equals([88, 202, 271, 398, 527, 662]),
      );
      expect(
        issues.map((issue) => issue.location.start.line),
        equals([6, 15, 20, 25, 30, 36]),
      );
      expect(
        issues.map((issue) => issue.location.start.column),
        equals([3, 3, 3, 3, 3, 1]),
      );
      expect(
        issues.map((issue) => issue.location.end.offset),
        equals([144, 257, 327, 455, 590, 697]),
      );
      expect(
        issues.map((issue) => issue.location.text),
        equals([
          'Widget _getMyShinyWidget() {\n'
              '    return Container();\n'
              '  }',
          'Container _getContainer() {\n'
              '    return Container();\n'
              '  }',
          'Iterable<Widget> _getWidgetsIterable() => [Container()];',
          'List<Widget> _getWidgetsList() => [Container()].toList();',
          'Future<Widget> _getWidgetFuture() => Future.value(Container());',
          'Widget _getWidget() => Container();',
        ]),
      );
      expect(
        issues.map((issue) => issue.message),
        equals([
          'Avoid returning widgets from a function',
          'Avoid returning widgets from a function',
          'Avoid returning widgets from a function',
          'Avoid returning widgets from a function',
          'Avoid returning widgets from a function',
          'Avoid returning widgets from a function',
        ]),
      );
    });

    test('reports about found issues with a custom config', () async {
      final path = File(_examplePath).absolute.path;
      final sourceUrl = Uri.parse(path);

      // ignore: deprecated_member_use
      final parseResult = await resolveFile(path: path);

      final config = {
        'ignored-names': [
          '_getWidgetFuture',
          '_getWidget',
        ],
      };

      final issues = AvoidReturningWidgets(config: config).check(
        ProcessedFile(sourceUrl, parseResult.content, parseResult.unit),
      );

      expect(
        issues.map((issue) => issue.location.start.offset),
        equals([88, 202, 271, 398]),
      );
      expect(
        issues.map((issue) => issue.location.start.line),
        equals([6, 15, 20, 25]),
      );
      expect(
        issues.map((issue) => issue.location.start.column),
        equals([3, 3, 3, 3]),
      );
      expect(
        issues.map((issue) => issue.location.end.offset),
        equals([144, 257, 327, 455]),
      );
      expect(
        issues.map((issue) => issue.location.text),
        equals([
          'Widget _getMyShinyWidget() {\n'
              '    return Container();\n'
              '  }',
          'Container _getContainer() {\n'
              '    return Container();\n'
              '  }',
          'Iterable<Widget> _getWidgetsIterable() => [Container()];',
          'List<Widget> _getWidgetsList() => [Container()].toList();',
        ]),
      );
      expect(
        issues.map((issue) => issue.message),
        equals([
          'Avoid returning widgets from a function',
          'Avoid returning widgets from a function',
          'Avoid returning widgets from a function',
          'Avoid returning widgets from a function',
        ]),
      );
    });
  });
}
