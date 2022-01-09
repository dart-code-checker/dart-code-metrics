import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/metrics_list/halstead_volume/halstead_volume_ast_visitor.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/scope_visitor.dart';
import 'package:test/test.dart';

import '../../../../../helpers/file_resolver.dart';

const _examplePath = './test/resources/halstead_volume_metric_example.dart';

Future<void> main() async {
  final result = await FileResolver.resolve(_examplePath);

  group('HalsteadVolumeAstVisitor collect information about', () {
    final scopeVisitor = ScopeVisitor();
    result.unit.visitChildren(scopeVisitor);

    test('block function', () {
      final visitor = HalsteadVolumeAstVisitor();
      scopeVisitor.functions.first.declaration.visitChildren(visitor);

      expect(visitor.operators, equals(9));
      expect(visitor.uniqueOperators, equals(5));
      expect(visitor.operands, equals(23));
      expect(visitor.uniqueOperands, equals(15));
    });

    test('expression function', () {
      final visitor = HalsteadVolumeAstVisitor();
      scopeVisitor.functions.last.declaration.visitChildren(visitor);

      expect(visitor.operators, equals(1));
      expect(visitor.uniqueOperators, equals(1));
      expect(visitor.operands, equals(4));
      expect(visitor.uniqueOperands, equals(4));
    });
  });
}
