import 'package:analyzer/dart/ast/ast.dart';

import '../../../../../utils/node_utils.dart';
import '../../../../../utils/string_extension.dart';
import '../../../models/context_message.dart';
import '../../../models/entity_type.dart';
import '../../../models/internal_resolved_unit_result.dart';
import '../../../models/scoped_class_declaration.dart';
import '../../../models/scoped_function_declaration.dart';
import '../../metric_utils.dart';
import '../../models/function_metric.dart';
import '../../models/metric_computation_result.dart';
import '../../models/metric_documentation.dart';
import 'nesting_level_visitor.dart';

const _documentation = MetricDocumentation(
  name: 'Maximum Nesting Level',
  shortName: 'MAXNESTING',
  brief: 'The maximum nesting level of control structures within a method',
  measuredType: EntityType.methodEntity,
  examples: [],
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
          threshold: readThreshold<int>(config, metricId, 5),
          levelComputer: valueLevel,
        );

  @override
  MetricComputationResult<int> computeImplementation(
    Declaration node,
    Iterable<ScopedClassDeclaration> classDeclarations,
    Iterable<ScopedFunctionDeclaration> functionDeclarations,
    InternalResolvedUnitResult source,
  ) {
    final visitor = NestingLevelVisitor(node);
    node.visitChildren(visitor);

    return MetricComputationResult(
      value: visitor.deepestNestedNodesChain.length,
      context: _context(visitor.deepestNestedNodesChain, source),
    );
  }

  @override
  String commentMessage(String nodeType, int value, int threshold) {
    final exceeds = value > threshold
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
