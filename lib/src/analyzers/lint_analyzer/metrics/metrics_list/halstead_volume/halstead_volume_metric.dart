import 'dart:math';

import 'package:analyzer/dart/ast/ast.dart';

import '../../../models/entity_type.dart';
import '../../../models/internal_resolved_unit_result.dart';
import '../../../models/scoped_class_declaration.dart';
import '../../../models/scoped_function_declaration.dart';
import '../../metric_utils.dart';
import '../../models/function_metric.dart';
import '../../models/metric_computation_result.dart';
import '../../models/metric_documentation.dart';
import '../../models/metric_value.dart';
import 'halstead_volume_ast_visitor.dart';

const _documentation = MetricDocumentation(
  name: 'Halstead Volume',
  shortName: 'HALVOL',
  measuredType: EntityType.methodEntity,
  recommendedThreshold: 150,
);

/// Halstead Volume (HALVOL)
///
/// The Halstead Volume is based on the Length and the Vocabulary. You can view
/// this as the ‘bulk’ of the code – how much information does the reader of the
/// code have to absorb to understand its meaning. The biggest influence on the
/// Volume metric is the Halstead length which causes a linear increase in the
/// Volume i.e doubling the Length will double the Volume. In the case of the
/// Vocabulary the increase is logarithmic.
class HalsteadVolumeMetric extends FunctionMetric<double> {
  static const String metricId = 'halstead-volume';

  HalsteadVolumeMetric({Map<String, Object> config = const {}})
      : super(
          id: metricId,
          documentation: _documentation,
          threshold: readNullableThreshold<double>(config, metricId),
          levelComputer: valueLevel,
        );

  @override
  MetricComputationResult<double> computeImplementation(
    AstNode node,
    Iterable<ScopedClassDeclaration> classDeclarations,
    Iterable<ScopedFunctionDeclaration> functionDeclarations,
    InternalResolvedUnitResult source,
    Iterable<MetricValue> otherMetricsValues,
  ) {
    final visitor = HalsteadVolumeAstVisitor();
    node.visitChildren(visitor);

    // LTH (length) - the sum of the number of operators and the number of operands.
    final lth = visitor.operators + visitor.operands;

    // VOC (vocabulary) – the the number of unique operators and the number of unique operands.
    final voc = visitor.uniqueOperators + visitor.uniqueOperands;

    // VOL (volume) – based on the length and the vocabulary.
    final vol = voc != 0 ? lth * _log2(voc) : 0.0;

    return MetricComputationResult<double>(value: vol);
  }

  @override
  String commentMessage(String nodeType, double value, double? threshold) {
    final exceeds = threshold != null && value > threshold
        ? ', which exceeds the maximum of $threshold allowed'
        : '';

    return 'This $nodeType has a halstead volume of $value$exceeds.';
  }

  double _log2(int a) => log(max(1, a)) / ln2;
}
