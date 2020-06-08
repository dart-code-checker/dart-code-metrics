@TestOn('vm')
import 'package:dart_code_metrics/src/metrics/cyclomatic_complexity/cyclomatic_config.dart';
import 'package:test/test.dart';

void main() {
  group('CyclomaticConfig complexityByControlFlowType', () {
    const flowTypes = [
      'assertStatement',
      'blockFunctionBody',
      'catchClause',
      'conditionalExpression',
      'forEachStatement',
      'forStatement',
      'ifStatement',
      'switchDefault',
      'switchCase',
      'whileStatement',
      'yieldStatement',
    ];

    test('returns complexity for flow type', () {
      expect(
          flowTypes
              .map(defaultCyclomaticConfig.complexityByControlFlowType)
              .toSet()
              .first,
          equals(1));
    });

    test('throws exception for unknown flow type', () {
      expect(() {
        defaultCyclomaticConfig.complexityByControlFlowType('unknown type');
      }, throwsArgumentError);
    });

    test('with custom config', () {
      const customComplexity = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
      final config = CyclomaticConfig(complexity: customComplexity);
      expect(flowTypes.map(config.complexityByControlFlowType),
          equals(customComplexity));
    });
  });
}
