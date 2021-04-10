@TestOn('vm')
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:dart_code_metrics/src/scope_visitor.dart';
import 'package:dart_code_metrics/src/metrics/cyclomatic_complexity/cyclomatic_complexity_flow_visitor.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

const _examplePath =
    './test/resources/cyclomatic_complexity_metric_example.dart';

Future<void> main() async {
  final result = await resolveFile(path: p.normalize(p.absolute(_examplePath)));

  group(
    'CyclomaticComplexityFlowVisitor collect information about cyclomatic complexity in',
    () {
      final scopeVisitor = ScopeVisitor();
      result!.unit!.visitChildren(scopeVisitor);

      test('very complex function', () {
        final declaration = scopeVisitor.functions.first.declaration;

        final visitor = CyclomaticComplexityFlowVisitor();
        declaration.visitChildren(visitor);

        expect(visitor.complexityEntities, hasLength(14));
      });

      test('common function', () {
        final declaration = scopeVisitor.functions.toList()[1].declaration;

        final visitor = CyclomaticComplexityFlowVisitor();
        declaration.visitChildren(visitor);

        expect(visitor.complexityEntities, hasLength(2));
      });

      test('empty function', () {
        final declaration = scopeVisitor.functions.last.declaration;

        final visitor = CyclomaticComplexityFlowVisitor();
        declaration.visitChildren(visitor);

        expect(visitor.complexityEntities, isEmpty);
      });
    },
  );
}
