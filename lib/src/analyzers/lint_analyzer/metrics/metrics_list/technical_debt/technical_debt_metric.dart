import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/syntactic_entity.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/type.dart';

import '../../../../../utils/node_utils.dart';
import '../../../models/context_message.dart';
import '../../../models/entity_type.dart';
import '../../../models/internal_resolved_unit_result.dart';
import '../../../models/scoped_class_declaration.dart';
import '../../../models/scoped_function_declaration.dart';
import '../../metric_utils.dart';
import '../../models/file_metric.dart';
import '../../models/metric_computation_result.dart';
import '../../models/metric_documentation.dart';
import '../../models/metric_value.dart';

part 'visitor.dart';

const _documentation = MetricDocumentation(
  name: 'Technical Debt',
  shortName: 'TECHDEBT',
  measuredType: EntityType.fileEntity,
  recommendedThreshold: 0,
);

/// Technical Debt (TECHDEBT)
///
/// Technical debt is a concept in software development that reflects the
/// implied cost of additional rework caused by choosing an easy solution now
/// instead of using a better approach that would take longer.
class TechnicalDebtMetric extends FileMetric<double> {
  static const String metricId = 'technical-debt';

  final double _todoCommentCost;
  final double _ignoreCommentCost;
  final double _ignoreForFileCommentCost;
  final double _asDynamicExpressionCost;
  final double _deprecatedAnnotationsCost;
  final double _fileNullSafetyMigrationCost;
  final String? _unitType;

  TechnicalDebtMetric({Map<String, Object> config = const {}})
      : _todoCommentCost =
            readConfigValue<double>(config, metricId, 'todo-cost') ?? 0.0,
        _ignoreCommentCost =
            readConfigValue<double>(config, metricId, 'ignore-cost') ?? 0.0,
        _ignoreForFileCommentCost =
            readConfigValue<double>(config, metricId, 'ignore-for-file-cost') ??
                0.0,
        _asDynamicExpressionCost =
            readConfigValue<double>(config, metricId, 'as-dynamic-cost') ?? 0.0,
        _deprecatedAnnotationsCost = readConfigValue<double>(
              config,
              metricId,
              'deprecated-annotations-cost',
            ) ??
            0.0,
        _fileNullSafetyMigrationCost = readConfigValue<double>(
              config,
              metricId,
              'file-nullsafety-migration-cost',
            ) ??
            0.0,
        _unitType = readConfigValue<String>(config, metricId, 'unit-type'),
        super(
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
    var debt = 0.0;

    final visitor = _Visitor()..visitComments(node);
    node.visitChildren(visitor);

    debt += visitor.todos.length * _todoCommentCost;
    debt += visitor.ignore.length * _ignoreCommentCost;
    debt += visitor.ignoreForFile.length * _ignoreForFileCommentCost;
    debt += visitor.asDynamicExpressions.length * _asDynamicExpressionCost;
    debt += visitor.deprecatedAnnotations.length * _deprecatedAnnotationsCost;
    debt += visitor.nonNullSafetyLanguageComment.length *
        _fileNullSafetyMigrationCost;

    return MetricComputationResult(
      value: debt,
      context: [
        if (_todoCommentCost > 0.0)
          ..._context(visitor.todos, source, _todoCommentCost),
        if (_ignoreCommentCost > 0.0)
          ..._context(visitor.ignore, source, _ignoreCommentCost),
        if (_ignoreForFileCommentCost > 0.0)
          ..._context(visitor.ignoreForFile, source, _ignoreForFileCommentCost),
        if (_asDynamicExpressionCost > 0.0)
          ..._context(
            visitor.asDynamicExpressions,
            source,
            _asDynamicExpressionCost,
          ),
        if (_deprecatedAnnotationsCost > 0.0)
          ..._context(
            visitor.deprecatedAnnotations,
            source,
            _deprecatedAnnotationsCost,
          ),
        if (_fileNullSafetyMigrationCost > 0.0)
          ..._context(
            visitor.nonNullSafetyLanguageComment,
            source,
            _fileNullSafetyMigrationCost,
          ),
      ],
    );
  }

  @override
  String commentMessage(String nodeType, double value, double? threshold) {
    final exceeds = threshold != null && value > threshold
        ? ', exceeds the maximum of $threshold allowed'
        : '';
    final debt = '$value swe ${value == 1 ? 'hour' : 'hours'} of debt';

    return 'This $nodeType has $debt$exceeds.';
  }

  @override
  String? unitType(double value) => _unitType;

  Iterable<ContextMessage> _context(
    Iterable<SyntacticEntity> complexityEntities,
    InternalResolvedUnitResult source,
    double cost,
  ) =>
      complexityEntities
          .map((entity) => ContextMessage(
                message: '+$cost ${_unitType ?? ''}'.trim(),
                location: nodeLocation(node: entity, source: source),
              ))
          .toList()
        ..sort((a, b) => a.location.start.compareTo(b.location.start));
}
