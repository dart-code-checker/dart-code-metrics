import 'package:analyzer/dart/ast/ast.dart';

import '../../models/entity_type.dart';
import '../../models/internal_resolved_unit_result.dart';
import '../../models/scoped_class_declaration.dart';
import '../../models/scoped_function_declaration.dart';
import '../metric_utils.dart';
import '../models/function_metric.dart';
import '../models/metric_computation_result.dart';
import '../models/metric_documentation.dart';

const _documentation = MetricDocumentation(
  name: 'Number of Parameters',
  shortName: 'NOP',
  brief: 'Number of parameters received by a method',
  measuredType: EntityType.methodEntity,
  recomendedThreshold: 4,
);

/// Number of Parameters (NOP)
///
/// Simply counts the number of parameters received by a method.
class NumberOfParametersMetric extends FunctionMetric<int> {
  static const String metricId = 'number-of-parameters';

  /// Initialize a newly created [NumberOfParametersMetric] with passed [config].
  NumberOfParametersMetric({Map<String, Object> config = const {}})
      : super(
          id: metricId,
          documentation: _documentation,
          threshold: readNullableThreshold<int>(config, metricId),
          levelComputer: valueLevel,
        );

  @override
  MetricComputationResult<int> computeImplementation(
    Declaration node,
    Iterable<ScopedClassDeclaration> classDeclarations,
    Iterable<ScopedFunctionDeclaration> functionDeclarations,
    InternalResolvedUnitResult source,
  ) {
    int? parametersCount;
    if (node is FunctionDeclaration) {
      parametersCount = node.functionExpression.parameters?.parameters.length;
    } else if (node is MethodDeclaration) {
      parametersCount = node.parameters?.parameters.length;
    }

    return MetricComputationResult(value: parametersCount ?? 0);
  }

  @override
  String commentMessage(String nodeType, int value, int? threshold) {
    final exceeds = threshold != null && value > threshold
        ? ', exceeds the maximum of $threshold allowed'
        : '';
    final parameters = '$value ${value == 1 ? 'parameter' : 'parameters'}';

    return 'This $nodeType has $parameters$exceeds.';
  }
}
