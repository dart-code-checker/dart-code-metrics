import 'package:analyzer/dart/ast/ast.dart';

import '../../../../utils/node_utils.dart';
import '../../models/context_message.dart';
import '../../models/entity_type.dart';
import '../../models/function_type.dart';
import '../../models/internal_resolved_unit_result.dart';
import '../../models/scoped_class_declaration.dart';
import '../../models/scoped_function_declaration.dart';
import '../metric_utils.dart';
import '../models/class_metric.dart';
import '../models/metric_computation_result.dart';
import '../models/metric_documentation.dart';
import '../scope_utils.dart';

const _documentation = MetricDocumentation(
  name: 'Weight Of a Class',
  shortName: 'WOC',
  brief:
      'The number of "functional" public methods divided by the total number of public members',
  measuredType: EntityType.classEntity,
  recomendedThreshold: 0.33,
);

/// Weight Of a Class (WOC)
///
/// Number of **functional** public methods divided by the total number of public methods
class WeightOfClassMetric extends ClassMetric<double> {
  static const String metricId = 'weight-of-class';

  /// Initialize a newly created [WeightOfClassMetric] with passed [config].
  WeightOfClassMetric({Map<String, Object> config = const {}})
      : super(
          id: metricId,
          documentation: _documentation,
          threshold: readNullableThreshold<double>(config, metricId),
          levelComputer: invertValueLevel,
        );

  @override
  bool supports(
    Declaration node,
    Iterable<ScopedClassDeclaration> classDeclarations,
    Iterable<ScopedFunctionDeclaration> functionDeclarations,
    InternalResolvedUnitResult source,
  ) =>
      super.supports(node, classDeclarations, functionDeclarations, source) &&
      classMethods(node, functionDeclarations)
          .where(_isPublicMethod)
          .isNotEmpty;

  @override
  MetricComputationResult<double> computeImplementation(
    Declaration node,
    Iterable<ScopedClassDeclaration> classDeclarations,
    Iterable<ScopedFunctionDeclaration> functionDeclarations,
    InternalResolvedUnitResult source,
  ) {
    final totalPublicMethods = classMethods(node, functionDeclarations)
        .where(_isPublicMethod)
        .toList(growable: false);

    final functionalMethods =
        totalPublicMethods.where(_isFunctionalMethod).toList(growable: false);

    return MetricComputationResult(
      value: functionalMethods.length / totalPublicMethods.length,
      context: _context(functionalMethods, totalPublicMethods, source),
    );
  }

  @override
  String commentMessage(String nodeType, double value, double? threshold) {
    final exceeds = threshold != null && value < threshold
        ? ', which is lower then the threshold of $threshold allowed'
        : '';

    return 'This $nodeType has a weight of $value$exceeds.';
  }

  bool _isPublicMethod(ScopedFunctionDeclaration function) =>
      !Identifier.isPrivateName(function.name);

  bool _isFunctionalMethod(ScopedFunctionDeclaration function) {
    const _nonFunctionalTypes = {
      FunctionType.constructor,
      FunctionType.setter,
      FunctionType.getter,
    };

    return !_nonFunctionalTypes.contains(function.type);
  }

  Iterable<ContextMessage> _context(
    Iterable<ScopedFunctionDeclaration> functionalMethods,
    Iterable<ScopedFunctionDeclaration> totalMethods,
    InternalResolvedUnitResult source,
  ) =>
      totalMethods
          .map((func) => ContextMessage(
                message: functionalMethods.contains(func)
                    ? 'functional ${func.type} ${func.name} increase metric value'
                    : 'public ${func.type} ${func.name} decrease metric value',
                location: nodeLocation(node: func.declaration, source: source),
              ))
          .toList(growable: false);
}
