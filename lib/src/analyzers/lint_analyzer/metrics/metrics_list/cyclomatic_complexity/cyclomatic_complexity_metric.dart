import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/syntactic_entity.dart';
import 'package:analyzer/dart/ast/token.dart';

import '../../../../../utils/node_utils.dart';
import '../../../../../utils/string_extensions.dart';
import '../../../models/context_message.dart';
import '../../../models/entity_type.dart';
import '../../../models/internal_resolved_unit_result.dart';
import '../../../models/scoped_class_declaration.dart';
import '../../../models/scoped_function_declaration.dart';
import '../../metric_utils.dart';
import '../../models/function_metric.dart';
import '../../models/metric_computation_result.dart';
import '../../models/metric_documentation.dart';
import '../../models/metric_value.dart';
import 'cyclomatic_complexity_flow_visitor.dart';

const _documentation = MetricDocumentation(
  name: 'Cyclomatic Complexity',
  shortName: 'CYCLO',
  measuredType: EntityType.methodEntity,
  recommendedThreshold: 20,
);

/// Cyclomatic Complexity (CYCLO)
///
/// Cyclomatic complexity is a measure of the code's complexity achieved by
/// measuring the number of linearly independent paths through a source code.
class CyclomaticComplexityMetric extends FunctionMetric<int> {
  static const String metricId = 'cyclomatic-complexity';

  /// Initialize a newly created [CyclomaticComplexityMetric] with passed [config].
  CyclomaticComplexityMetric({Map<String, Object> config = const {}})
      : super(
          id: metricId,
          documentation: _documentation,
          threshold: readNullableThreshold<int>(config, metricId),
          levelComputer: valueLevel,
        );

  @override
  MetricComputationResult<int> computeImplementation(
    AstNode node,
    Iterable<ScopedClassDeclaration> classDeclarations,
    Iterable<ScopedFunctionDeclaration> functionDeclarations,
    InternalResolvedUnitResult source,
    Iterable<MetricValue> otherMetricsValues,
  ) {
    final visitor = CyclomaticComplexityFlowVisitor();
    node.visitChildren(visitor);

    return MetricComputationResult(
      value: visitor.complexityEntities.length + 1,
      context: _context(visitor.complexityEntities, source),
    );
  }

  @override
  String commentMessage(String nodeType, int value, int? threshold) {
    final exceeds = threshold != null && value > threshold
        ? ', which exceeds the maximum of $threshold allowed'
        : '';

    return 'This $nodeType has a cyclomatic complexity of $value$exceeds.';
  }

  Iterable<ContextMessage> _context(
    Iterable<SyntacticEntity> complexityEntities,
    InternalResolvedUnitResult source,
  ) =>
      complexityEntities.map((entity) {
        String? message;

        if (entity is AstNode) {
          message = userFriendlyType(entity.runtimeType).camelCaseToText();
        } else if (entity is Token) {
          message = 'Operator ${entity.lexeme}';
        }

        return ContextMessage(
          message: '${message?.capitalize()} increases complexity',
          location: nodeLocation(node: entity, source: source),
        );
      }).toList()
        ..sort((a, b) => a.location.start.compareTo(b.location.start));
}
