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
        startOffsets: [88, 175, 289, 358, 485, 614, 749, 822, 895],
        startLines: [6, 11, 20, 25, 30, 35, 41, 46, 50],
        startColumns: [3, 3, 3, 3, 3, 3, 1, 1, 1],
        endOffsets: [127, 231, 344, 414, 542, 677, 784, 885, 954],
        locationTexts: [
          'Widget get widgetGetter => Container();',
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
          '@FunctionalWidget\n'
              'Widget _getFunctionalWidget() => Container();',
          '@swidget\n'
              'Widget _getOtherFunctionalWidget() => Container();',
        ],
        messages: [
          'Avoid returning widgets from a function.',
          'Avoid returning widgets from a function.',
          'Avoid returning widgets from a function.',
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
        'ignored-annotations': [
          'FunctionalWidget',
          'swidget',
        ]
      };

      final issues = AvoidReturningWidgetsRule(config).check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startOffsets: [88, 175, 289, 358, 485],
        startLines: [6, 11, 20, 25, 30],
        startColumns: [3, 3, 3, 3, 3],
        endOffsets: [127, 231, 344, 414, 542],
        locationTexts: [
          'Widget get widgetGetter => Container();',
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
          'Avoid returning widgets from a function.',
        ],
      );
    });
  });
}
