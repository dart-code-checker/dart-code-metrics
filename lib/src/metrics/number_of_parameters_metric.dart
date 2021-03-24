import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';

import '../models/entity_type.dart';
import '../models/metric_documentation.dart';
import '../models/scoped_class_declaration.dart';
import '../models/scoped_function_declaration.dart';
import '../utils/metric_utils.dart';
import 'function_metric.dart';
import 'metric_computation_result.dart';

const _documentation = MetricDocumentation(
  name: 'Number of Parameters',
  shortName: 'NOP',
  brief: 'Number of parameters received by a method',
  measuredType: EntityType.methodEntity,
  examples: [],
);

/// Number of Parameters (NOP)
///
/// Simply counts the number of parameters received by a method.
class NumberOfParametersMetric extends FunctionMetric<int> {
  /// Id of this metric.
  static const String metricId = 'number-of-parameters';

  /// Initialize a newly created [NumberOfParametersMetric] with passed [config].
  NumberOfParametersMetric({Map<String, Object> config = const {}})
      : super(
          id: metricId,
          documentation: _documentation,
          threshold: readThreshold<int>(config, metricId, 4),
          levelComputer: valueLevel,
        );

  @override
  MetricComputationResult<int> computeImplementation(
    Declaration node,
    Iterable<ScopedClassDeclaration> classDeclarations,
    Iterable<ScopedFunctionDeclaration> functionDeclarations,
    ResolvedUnitResult source,
  ) {
    int parametersCount;
    if (node is FunctionDeclaration) {
      parametersCount = node.functionExpression?.parameters?.parameters?.length;
    } else if (node is MethodDeclaration) {
      parametersCount = node?.parameters?.parameters?.length;
    }

    return MetricComputationResult(value: parametersCount ?? 0);
  }

  @override
  String commentMessage(String nodeType, int value, int threshold) {
    final exceeds =
        value > threshold ? ', exceeds the maximum of $threshold allowed' : '';
    final parameters = '$value ${value == 1 ? 'parameter' : 'parameters'}';

    return 'This $nodeType has $parameters$exceeds.';
  }
}
