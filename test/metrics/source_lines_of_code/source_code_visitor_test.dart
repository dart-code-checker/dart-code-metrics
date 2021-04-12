@TestOn('vm')
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:dart_code_metrics/src/metrics/source_lines_of_code/source_code_visitor.dart';
import 'package:dart_code_metrics/src/scope_visitor.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

const _examplePath =
    './test/resources/source_lines_of_code_metric_example.dart';

Future<void> main() async {
  // ignore: deprecated_member_use
  final result = await resolveFile(path: p.normalize(p.absolute(_examplePath)));

  group('SourceCodeVisitor collects information about source lines', () {
    final scopeVisitor = ScopeVisitor();
    result!.unit!.visitChildren(scopeVisitor);

    test('in simple function', () {
      final declaration = scopeVisitor.functions.first.declaration;

      final sourceCodeVisitor = SourceCodeVisitor(result.lineInfo);
      declaration.visitChildren(sourceCodeVisitor);

      expect(sourceCodeVisitor.linesWithCode, equals([11]));
    });

    test('in block function', () {
      final declaration = scopeVisitor.functions.toList()[1].declaration;

      final sourceCodeVisitor = SourceCodeVisitor(result.lineInfo);
      declaration.visitChildren(sourceCodeVisitor);

      expect(sourceCodeVisitor.linesWithCode, equals([22, 23, 25, 26, 27, 28]));
    });

    test('in arrow method', () {
      final declaration = scopeVisitor.functions.last.declaration;

      final sourceCodeVisitor = SourceCodeVisitor(result.lineInfo);
      declaration.visitChildren(sourceCodeVisitor);

      expect(sourceCodeVisitor.linesWithCode, equals([32, 33, 34, 35]));
    });
  });
}
