import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/metrics_list/cyclomatic_complexity/cyclomatic_complexity_flow_visitor.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/scope_visitor.dart';
import 'package:test/test.dart';

import '../../../../../helpers/file_resolver.dart';

const _examplePath =
    './test/resources/cyclomatic_complexity_metric_example.dart';

Future<void> main() async {
  final result = await FileResolver.resolve(_examplePath);

  group(
    'CyclomaticComplexityFlowVisitor collect information about cyclomatic complexity in',
    () {
      final scopeVisitor = ScopeVisitor();
      result.unit.visitChildren(scopeVisitor);

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
        final declaration = scopeVisitor.functions.toList()[2].declaration;

        final visitor = CyclomaticComplexityFlowVisitor();
        declaration.visitChildren(visitor);

        expect(visitor.complexityEntities, isEmpty);
      });

      test('function with blocks', () {
        final declaration = scopeVisitor.functions.toList()[3].declaration;

        final visitor = CyclomaticComplexityFlowVisitor();
        declaration.visitChildren(visitor);

        expect(visitor.complexityEntities, hasLength(3));
      });
    },
  );
}
