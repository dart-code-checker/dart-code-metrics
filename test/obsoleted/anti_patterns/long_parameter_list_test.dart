@TestOn('vm')
import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:code_checker/checker.dart';
import 'package:dart_code_metrics/src/obsoleted/anti_patterns/long_parameter_list.dart';
import 'package:dart_code_metrics/src/obsoleted/config/config.dart' as metrics;
import 'package:dart_code_metrics/src/obsoleted/models/internal_resolved_unit_result.dart';
import 'package:test/test.dart';

const _content = '''

void main() {}

void func(int a, int b, int c, int e) {}

void func2(int a, int b, int c, int e, String f) {}

''';

void main() {
  test('LongParameterList report about found design issues', () {
    final sourceUrl = Uri.parse('/example.dart');

    final parseResult = parseString(
      content: _content,
      // ignore: deprecated_member_use
      featureSet: FeatureSet.fromEnableFlags([]),
      throwIfDiagnostics: false,
    );

    final scopeVisitor = ScopeVisitor();
    parseResult.unit.visitChildren(scopeVisitor);

    final issues = LongParameterList().check(
      InternalResolvedUnitResult(
        sourceUrl,
        parseResult.content,
        parseResult.unit,
      ),
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
      const metrics.Config(),
    );

    expect(issues, hasLength(1));

    final issue = issues.single;
    final issueSrcSpan = issue.location;
    expect(issue.ruleId, equals('long-parameter-list'));
    expect(
      issue.documentation.toString(),
      equals('https://git.io/JUGrU'),
    );
    expect(issueSrcSpan.sourceUrl, equals(sourceUrl));
    expect(issueSrcSpan.start.offset, equals(59));
    expect(issueSrcSpan.start.line, equals(6));
    expect(issueSrcSpan.start.column, equals(1));
    expect(issueSrcSpan.end.offset, equals(110));
    expect(
      issue.message,
      equals('Long Parameter List. This function require 5 arguments.'),
    );
    expect(
      issue.verboseMessage,
      equals(
        "Based on configuration of this package, we don't recommend writing a function with argument count more than 4.",
      ),
    );
  });
}
