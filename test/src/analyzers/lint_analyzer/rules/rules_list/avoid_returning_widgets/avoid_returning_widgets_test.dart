@TestOn('vm')
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/avoid_returning_widgets/avoid_returning_widgets.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

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
        startOffsets: [755, 791, 827, 859, 892, 961, 292, 1016, 1271],
        startLines: [36, 38, 40, 42, 44, 47, 16, 53, 67],
        startColumns: [5, 5, 5, 5, 5, 14, 3, 1, 1],
        endOffsets: [776, 812, 844, 877, 915, 984, 331, 1071, 1346],
        locationTexts: [
          '_localBuildMyWidget()',
          '_getWidgetsIterable()',
          '_getWidgetsList()',
          '_getWidgetFuture()',
          '_buildMyWidget(context)',
          '_buildMyWidget(context)',
          'Widget get widgetGetter => Container();',
          'Widget _globalBuildMyWidget() {\n'
              '  return Container();\n'
              '}',
          '@ignoredAnnotation\n'
              'Widget _getWidgetWithIgnoredAnnotation() => Container();',
        ],
        messages: [
          'Avoid returning widgets from a function.',
          'Avoid returning widgets from a function.',
          'Avoid returning widgets from a function.',
          'Avoid returning widgets from a function.',
          'Avoid returning widgets from a function.',
          'Avoid returning widgets from a function.',
          'Avoid returning widgets from a getter.',
          'Avoid returning widgets from a global function.',
          'Avoid returning widgets from a global function.',
        ],
      );
    });

    test('reports about found issues with a custom config', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final config = {
        'ignored-names': [
          '_getWidgetFuture',
          '_buildMyWidget',
        ],
        'ignored-annotations': [
          'ignoredAnnotation',
        ],
      };

      final issues = AvoidReturningWidgetsRule(config).check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startOffsets: [755, 791, 827, 292, 1016, 1073, 1138, 1203],
        startLines: [36, 38, 40, 16, 53, 57, 60, 63],
        startColumns: [5, 5, 5, 3, 1, 1, 1, 1],
        endOffsets: [776, 812, 844, 331, 1071, 1136, 1201, 1261],
        locationTexts: [
          '_localBuildMyWidget()',
          '_getWidgetsIterable()',
          '_getWidgetsList()',
          'Widget get widgetGetter => Container();',
          'Widget _globalBuildMyWidget() {\n'
              '  return Container();\n'
              '}',
          '@FunctionalWidget\n'
              'Widget _getFunctionalWidget() => Container();',
          '@swidget\n'
              'Widget _getStatelessFunctionalWidget() => Container();',
          '@hwidget\n'
              'Widget _getHookFunctionalWidget() => Container();',
        ],
        messages: [
          'Avoid returning widgets from a function.',
          'Avoid returning widgets from a function.',
          'Avoid returning widgets from a function.',
          'Avoid returning widgets from a getter.',
          'Avoid returning widgets from a global function.',
          'Avoid returning widgets from a global function.',
          'Avoid returning widgets from a global function.',
          'Avoid returning widgets from a global function.',
        ],
      );
    });
  });
}
