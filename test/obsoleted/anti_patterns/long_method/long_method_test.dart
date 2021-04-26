@TestOn('vm')
import 'package:analyzer/dart/ast/ast.dart';
import 'package:dart_code_metrics/src/models/severity.dart';
import 'package:dart_code_metrics/src/obsoleted/anti_patterns/long_method.dart';
import 'package:dart_code_metrics/src/obsoleted/constants.dart';
import 'package:dart_code_metrics/src/scope_visitor.dart';
import 'package:test/test.dart';

import '../../../helpers/rule_test_helper.dart';

const _examplePath =
    'test/obsoleted/anti_patterns/long_method/examples/example.dart';

void main() {
  test('LongMethod report about found design issues', () async {
    final unit = await RuleTestHelper.resolveFromFile(_examplePath);

    final scopeVisitor = ScopeVisitor();
    unit.unit!.visitChildren(scopeVisitor);

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

    RuleTestHelper.verifyInitialization(
      issues: issues,
      ruleId: 'long-method',
      severity: Severity.none,
    );

    RuleTestHelper.verifyIssues(
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
