@TestOn('vm')
import 'package:analyzer/dart/ast/ast.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/anti_patterns/anti_patterns_list/long_method.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/metrics_list/source_lines_of_code/source_lines_of_code_metric.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/scope_visitor.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:test/test.dart';

import '../../../../../helpers/anti_patterns_test_helper.dart';

const _examplePath = 'long_method/examples/example.dart';
const _widgetExamplePath = 'long_method/examples/widget.dart';

void main() {
  group('LongMethod', () {
    test('report about found design issues', () async {
      final unit = await AntiPatternTestHelper.resolveFromFile(_examplePath);

      final scopeVisitor = ScopeVisitor();
      unit.unit.visitChildren(scopeVisitor);

      final issues = LongMethod().legacyCheck(
        unit,
        scopeVisitor.functions.where((function) {
          final declaration = function.declaration;
          if (declaration is ConstructorDeclaration &&
              declaration.body is EmptyFunctionBody) {
            return false;
          } else if (declaration is MethodDeclaration &&
              declaration.body is EmptyFunctionBody) {
            return false;
          }

          return true;
        }),
        {SourceLinesOfCodeMetric.metricId: 25},
      );

      AntiPatternTestHelper.verifyInitialization(
        issues: issues,
        antiPatternId: 'long-method',
        severity: Severity.none,
      );

      AntiPatternTestHelper.verifyIssues(
        issues: issues,
        startOffsets: [0],
        startLines: [1],
        startColumns: [1],
        endOffsets: [1309],
        messages: [
          'Long function. This function contains 29 lines with code.',
        ],
        verboseMessage: [
          "Based on configuration of this package, we don't recommend write a function longer than 25 lines with code.",
        ],
      );
    });

    test('skip widget build method', () async {
      final unit =
          await AntiPatternTestHelper.resolveFromFile(_widgetExamplePath);

      final scopeVisitor = ScopeVisitor();
      unit.unit.visitChildren(scopeVisitor);

      final issues = LongMethod().legacyCheck(
        unit,
        scopeVisitor.functions.where((function) {
          final declaration = function.declaration;
          if (declaration is ConstructorDeclaration &&
              declaration.body is EmptyFunctionBody) {
            return false;
          } else if (declaration is MethodDeclaration &&
              declaration.body is EmptyFunctionBody) {
            return false;
          }

          return true;
        }),
        {SourceLinesOfCodeMetric.metricId: 25},
      );

      expect(issues, isEmpty);
    });
  });
}
