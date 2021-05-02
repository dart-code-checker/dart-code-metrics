@TestOn('vm')
import 'package:analyzer/dart/ast/ast.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/anti_patterns/anti_patterns_list/long_method.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/constants.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/scope_visitor.dart';
import 'package:dart_code_metrics/src/analyzers/models/severity.dart';
import 'package:test/test.dart';

import '../../../../../helpers/anti_patterns_test_helper.dart';

const _examplePath = 'long_method/examples/example.dart';

void main() {
  test('LongMethod report about found design issues', () async {
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
      {linesOfExecutableCodeKey: 25},
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
        'Long function. This function contains 29 lines with executable code.',
      ],
      verboseMessage: [
        "Based on configuration of this package, we don't recommend write a function longer than 25 lines with executable code.",
      ],
    );
  });
}
