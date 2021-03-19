@TestOn('vm')
import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:code_checker/checker.dart';
import 'package:dart_code_metrics/src/obsoleted/config/config.dart' as metrics;
import 'package:dart_code_metrics/src/obsoleted/anti_patterns/long_method.dart';
import 'package:dart_code_metrics/src/obsoleted/models/internal_resolved_unit_result.dart';
import 'package:test/test.dart';

const _content = '''

void main() {
  test('LongMethod report about found design issues', () {
    final sourceUrl = Uri.parse('/example.dart');

    final parseResult = parseString(
        content: _content,
        featureSet: FeatureSet.fromEnableFlags([]),
        throwIfDiagnostics: false);

    final issues = LongMethod().check(
        parseResult.unit,
        sourceUrl,
        parseResult.content,
        const Config(linesOfExecutableCodeWarningLevel: 25));

    expect(issues, hasLength(1));

    expect(issues.single.patternId, equals('long-method'));
    expect(issues.single.patternDocumentation.toString(),
        equals('https://git.io/JUIP7'));
    expect(issues.single.sourceSpan.sourceUrl, equals(sourceUrl));
    expect(issues.single.sourceSpan.start.offset, equals(1));
    expect(issues.single.sourceSpan.start.line, equals(2));
    expect(issues.single.sourceSpan.start.column, equals(1));
    expect(issues.single.sourceSpan.end.offset, equals(1310));
    expect(
        issues.single.message,
        equals(
            'Long Method. This method contains 29 lines with executable code.'));
    expect(
        issues.single.recommendation,
        equals(
            "Based on configuration of this package, we don't recommend write a method longer than 25 lines with executable code."));
  });
}

''';

void main() {
  test('LongMethod report about found design issues', () {
    final sourceUrl = Uri.parse('/example.dart');

    final parseResult = parseString(
      content: _content,
      // ignore: deprecated_member_use
      featureSet: FeatureSet.fromEnableFlags([]),
      throwIfDiagnostics: false,
    );

    final scopeVisitor = ScopeVisitor();
    parseResult.unit.visitChildren(scopeVisitor);

    final issues = LongMethod().check(
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
      const metrics.Config(linesOfExecutableCodeWarningLevel: 25),
    );

    expect(issues, hasLength(1));

    expect(issues.single.ruleId, equals('long-method'));
    expect(
      issues.single.documentation.toString(),
      equals('https://git.io/JUIP7'),
    );
    expect(issues.single.location.sourceUrl, equals(sourceUrl));
    expect(issues.single.location.start.offset, equals(1));
    expect(issues.single.location.start.line, equals(2));
    expect(issues.single.location.start.column, equals(1));
    expect(issues.single.location.end.offset, equals(1310));
    expect(
      issues.single.message,
      equals(
        'Long function. This function contains 29 lines with executable code.',
      ),
    );
    expect(
      issues.single.verboseMessage,
      equals(
        "Based on configuration of this package, we don't recommend write a function longer than 25 lines with executable code.",
      ),
    );
  });
}
