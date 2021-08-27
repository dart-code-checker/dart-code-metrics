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
  name: 'Lines of Code',
  shortName: 'LOC',
  brief:
      'The number of physical lines of code of a method, including blank lines and comments',
  measuredType: EntityType.methodEntity,
  recomendedThreshold: 100,
);

/// Lines of Code (LOC)
///
/// Simply counts the number of lines of code a method takes up in the source.
/// This metric doesn't discount comments or blank lines.
class LinesOfCodeMetric extends FunctionMetric<int> {
  static const String metricId = 'lines-of-code';

  /// Initialize a newly created [LinesOfCodeMetric] with passed [config].
  LinesOfCodeMetric({Map<String, Object> config = const {}})
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
  ) =>
      MetricComputationResult(
        value: 1 +
            source.lineInfo.getLocation(node.endToken.offset).lineNumber -
            source.lineInfo.getLocation(node.beginToken.offset).lineNumber,
      );

  @override
  String commentMessage(String nodeType, int value, int? threshold) {
    final exceeds = threshold != null && value > threshold
        ? ', exceeds the maximum of $threshold allowed'
        : '';
    final lines = '$value ${value == 1 ? 'line' : 'lines'} of code';

    return 'This $nodeType has $lines$exceeds.';
  }

  @override
  String? recommendationMessage(String nodeType, int value, int? threshold) =>
      (threshold != null && value > threshold)
          ? 'Consider breaking this $nodeType up into smaller parts.'
          : null;
}
