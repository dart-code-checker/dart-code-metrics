@TestOn('vm')
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/avoid_returning_widgets/avoid_returning_widgets.dart';
import 'package:dart_code_metrics/src/analyzers/models/severity.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

// ignore_for_file: no_adjacent_strings_in_list

const _examplePath = 'avoid_returning_widgets/examples/example.dart';

void main() {
  group('AvoidReturningWidgetsRule', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = AvoidReturningWidgetsRule().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'avoid-returning-widgets',
        severity: Severity.warning,
      );
    });

    test('reports about found issues with the default config', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = AvoidReturningWidgetsRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startOffsets: [88, 202, 271, 398, 527, 662],
        startLines: [6, 15, 20, 25, 30, 36],
        startColumns: [3, 3, 3, 3, 3, 1],
        endOffsets: [144, 257, 327, 455, 590, 697],
        locationTexts: [
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
        ],
        messages: [
          'Avoid returning widgets from a function.',
          'Avoid returning widgets from a function.',
          'Avoid returning widgets from a function.',
          'Avoid returning widgets from a function.',
          'Avoid returning widgets from a function.',
          'Avoid returning widgets from a function.',
        ],
      );
    });

    test('reports about found issues with a custom config', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final config = {
        'ignored-names': [
          '_getWidgetFuture',
          '_getWidget',
        ],
      };

      final issues = AvoidReturningWidgetsRule(config).check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startOffsets: [88, 202, 271, 398],
        startLines: [6, 15, 20, 25],
        startColumns: [3, 3, 3, 3],
        endOffsets: [144, 257, 327, 455],
        locationTexts: [
          'Widget _getMyShinyWidget() {\n'
              '    return Container();\n'
              '  }',
          'Container _getContainer() {\n'
              '    return Container();\n'
              '  }',
          'Iterable<Widget> _getWidgetsIterable() => [Container()];',
          'List<Widget> _getWidgetsList() => [Container()].toList();',
        ],
        messages: [
          'Avoid returning widgets from a function.',
          'Avoid returning widgets from a function.',
          'Avoid returning widgets from a function.',
          'Avoid returning widgets from a function.',
        ],
      );
    });
  });
}
