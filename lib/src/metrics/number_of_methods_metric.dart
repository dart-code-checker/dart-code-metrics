import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';

import '../models/context_message.dart';
import '../models/entity_type.dart';
import '../models/metric_documentation.dart';
import '../models/scoped_class_declaration.dart';
import '../models/scoped_function_declaration.dart';
import '../utils/metric_utils.dart';
import '../utils/node_utils.dart';
import '../utils/scope_utils.dart';
import 'class_metric.dart';
import 'metric_computation_result.dart';

const _documentation = MetricDocumentation(
  name: 'Number of Methods',
  shortName: 'NOM',
  brief: 'The number of methods of a class.',
  measuredType: EntityType.classEntity,
  examples: [],
);

/// Number of Methods (NOM)
///
/// The number of methods of a class
class NumberOfMethodsMetric extends ClassMetric<int> {
  /// Id of this metric.
  static const String metricId = 'number-of-methods';

  /// Initialize a newly created [NumberOfMethodsMetric] with passed [config].
  NumberOfMethodsMetric({Map<String, Object> config = const {}})
      : super(
          id: metricId,
          documentation: _documentation,
          threshold: readThreshold<int>(config, metricId, 10),
          levelComputer: valueLevel,
        );

  @override
  MetricComputationResult<int> computeImplementation(
    Declaration node,
    Iterable<ScopedClassDeclaration> classDeclarations,
    Iterable<ScopedFunctionDeclaration> functionDeclarations,
    ResolvedUnitResult source,
  ) {
    final methods = classMethods(node, functionDeclarations);

    return MetricComputationResult(
      value: methods.length,
      context: _context(methods, source),
    );
  }

  @override
  String commentMessage(String nodeType, int value, int threshold) {
    final methods = '$value ${value == 1 ? 'method' : 'methods'}';
    final exceeds = value > threshold
        ? ', which exceeds the maximum of $threshold allowed'
        : '';

    return 'This $nodeType has $methods$exceeds.';
  }

  @override
  String recommendationMessage(String nodeType, int value, int threshold) =>
      (value > threshold)
          ? 'Consider breaking this $nodeType up into smaller parts.'
          : null;

  Iterable<ContextMessage> _context(
    Iterable<ScopedFunctionDeclaration> methods,
    ResolvedUnitResult source,
  ) =>
      methods
          .map((func) => ContextMessage(
                message: '${func.type} ${func.name} increase metric value',
                location: nodeLocation(node: func.declaration, source: source),
              ))
          .toList(growable: false);
}
