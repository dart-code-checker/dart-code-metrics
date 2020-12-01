@TestOn('vm')
import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:dart_code_metrics/src/config/config.dart';
import 'package:dart_code_metrics/src/anti_patterns/long_parameter_list.dart';
import 'package:dart_code_metrics/src/models/source.dart';
import 'package:dart_code_metrics/src/scope_ast_visitor.dart';
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
      featureSet: FeatureSet.fromEnableFlags([]),
      throwIfDiagnostics: false,
    );

    final scopeVisitor = ScopeAstVisitor();
    parseResult.unit.visitChildren(scopeVisitor);

    final issues = LongParameterList().check(
        Source(sourceUrl, parseResult.content, parseResult.unit),
        scopeVisitor.functions,
        const Config());

    expect(issues.length, equals(1));

    final issue = issues.single;
    final issueSrcSpan = issue.sourceSpan;
    expect(issue.patternId, equals('long-parameter-list'));
    expect(
      issue.patternDocumentation.toString(),
      equals('https://git.io/JUGrU'),
    );
    expect(issueSrcSpan.sourceUrl, equals(sourceUrl));
    expect(issueSrcSpan.start.offset, equals(59));
    expect(issueSrcSpan.start.line, equals(6));
    expect(issueSrcSpan.start.column, equals(1));
    expect(issueSrcSpan.end.offset, equals(110));
    expect(
      issue.message,
      equals('Long Parameter List. This method require 5 arguments.'),
    );
    expect(
      issue.recommendation,
      equals(
          "Based on configuration of this package, we don't recommend writing a method with argument count more than 4."),
    );
  });
}
