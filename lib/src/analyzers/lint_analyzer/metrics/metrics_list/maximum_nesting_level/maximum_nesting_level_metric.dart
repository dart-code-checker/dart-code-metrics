import 'package:analyzer/dart/ast/ast.dart';

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
import 'nesting_level_visitor.dart';

const _documentation = MetricDocumentation(
  name: 'Maximum Nesting Level',
  shortName: 'MAXNESTING',
  measuredType: EntityType.methodEntity,
  recommendedThreshold: 5,
);

/// Maximum Nesting Level (MAXNESTING)
///
/// This is the maximum level of nesting blocks / control structures that are
/// present in a method (function). Code with deep nesting level are often
/// complex and tough to maintain.
class MaximumNestingLevelMetric extends FunctionMetric<int> {
  static const String metricId = 'maximum-nesting-level';

  /// Initialize a newly created [MaximumNestingLevelMetric] with passed [config].
  MaximumNestingLevelMetric({Map<String, Object> config = const {}})
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
    final visitor = NestingLevelVisitor(node);
    node.visitChildren(visitor);

    return MetricComputationResult(
      value: visitor.deepestNestedNodesChain.length,
      context: _context(visitor.deepestNestedNodesChain, source),
    );
  }

  @override
  String commentMessage(String nodeType, int value, int? threshold) {
    final exceeds = threshold != null && value > threshold
        ? ', which exceeds the maximum of $threshold allowed'
        : '';

    return 'This $nodeType has a nesting level of $value$exceeds.';
  }

  Iterable<ContextMessage> _context(
    Iterable<AstNode> nestingNodesChain,
    InternalResolvedUnitResult source,
  ) =>
      nestingNodesChain.where((block) => block.parent != null).map((block) {
        final message = userFriendlyType(block.parent.runtimeType)
            .camelCaseToText()
            .capitalize();

        return ContextMessage(
          message: '$message increases depth',
          location: nodeLocation(node: block, source: source),
        );
      }).toList()
        ..sort((a, b) => a.location.start.compareTo(b.location.start));
}
