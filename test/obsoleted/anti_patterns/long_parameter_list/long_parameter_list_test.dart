@TestOn('vm')
import 'package:analyzer/dart/ast/ast.dart';
import 'package:dart_code_metrics/src/metrics/number_of_parameters_metric.dart';
import 'package:dart_code_metrics/src/models/severity.dart';
import 'package:dart_code_metrics/src/obsoleted/anti_patterns/long_parameter_list.dart';
import 'package:dart_code_metrics/src/scope_visitor.dart';
import 'package:test/test.dart';

import '../../../helpers/anti_pattern_test_helper.dart';
import '../../../helpers/file_resolver.dart';

const _examplePath =
    'test/obsoleted/anti_patterns/long_parameter_list/examples/example.dart';

void main() {
  test('LongParameterList report about found design issues', () async {
    final unit = await FileResolver.resolve(_examplePath);

    final scopeVisitor = ScopeVisitor();
    unit.unit.visitChildren(scopeVisitor);

    final issues = LongParameterList().legacyCheck(
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
      {NumberOfParametersMetric.metricId: 4},
    );

    AntiPatternTestHelper.verifyInitialization(
      issues: issues,
      antiPatternId: 'long-parameter-list',
      severity: Severity.none,
    );

    AntiPatternTestHelper.verifyIssues(
      issues: issues,
      startOffsets: [58],
      startLines: [5],
      startColumns: [1],
      endOffsets: [109],
      messages: ['Long Parameter List. This function require 5 arguments.'],
      verboseMessage: [
        "Based on configuration of this package, we don't recommend writing a function with argument count more than 4.",
      ],
    );
  });
}
