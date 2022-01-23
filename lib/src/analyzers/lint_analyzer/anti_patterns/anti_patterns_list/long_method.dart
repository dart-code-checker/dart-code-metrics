// ignore_for_file: public_member_api_docs

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/type.dart';

import '../../../../utils/node_utils.dart';
import '../../lint_utils.dart';
import '../../metrics/metric_utils.dart';
import '../../metrics/metrics_list/source_lines_of_code/source_lines_of_code_metric.dart';
import '../../metrics/models/metric_value_level.dart';
import '../../models/entity_type.dart';
import '../../models/internal_resolved_unit_result.dart';
import '../../models/issue.dart';
import '../../models/report.dart';
import '../../models/scoped_class_declaration.dart';
import '../../models/scoped_function_declaration.dart';
import '../../models/severity.dart';
import '../../rules/flutter_rule_utils.dart';
import '../models/pattern.dart';
import '../pattern_utils.dart';

class LongMethod extends Pattern {
  static const String patternId = 'long-method';

  final int? _sourceLinesOfCodeMetricTreshold;

  @override
  Iterable<String> get dependentMetricIds => [SourceLinesOfCodeMetric.metricId];

  LongMethod({
    Map<String, Object> patternSettings = const {},
    Map<String, Object> metricstTresholds = const {},
  })  : _sourceLinesOfCodeMetricTreshold = readNullableThreshold<int>(
          metricstTresholds,
          SourceLinesOfCodeMetric.metricId,
        ),
        super(
          id: patternId,
          supportedType: EntityType.methodEntity,
          severity: readSeverity(patternSettings, Severity.none),
          excludes: readExcludes(patternSettings),
        );

  @override
  Iterable<Issue> check(
    InternalResolvedUnitResult source,
    Map<ScopedClassDeclaration, Report> classMetrics,
    Map<ScopedFunctionDeclaration, Report> functionMetrics,
  ) =>
      functionMetrics.entries
          .where((entry) => !_isExcluded(entry.key))
          .expand((entry) => [
                if (_sourceLinesOfCodeMetricTreshold != null)
                  ...entry.value.metrics
                      .where((metricValue) =>
                          metricValue.metricsId ==
                              SourceLinesOfCodeMetric.metricId &&
                          metricValue.value > _sourceLinesOfCodeMetricTreshold!)
                      .map(
                        (metricValue) => createIssue(
                          pattern: this,
                          location: nodeLocation(
                            node: entry.key.declaration,
                            source: source,
                          ),
                          message: _compileMessage(
                            lines: metricValue.value,
                            functionType: entry.key.type,
                          ),
                          verboseMessage: _compileRecommendationMessage(
                            maximumLines: _sourceLinesOfCodeMetricTreshold,
                            functionType: entry.key.type,
                          ),
                        ),
                      ),
                if (_sourceLinesOfCodeMetricTreshold == null)
                  // ignore: deprecated_member_use_from_same_package
                  ..._legacyBehaviour(source, entry),
              ])
          .toList();

  bool _isExcluded(ScopedFunctionDeclaration function) {
    final declaration = function.declaration;
    DartType? returnType;
    String? name;

    if (declaration is FunctionDeclaration) {
      returnType = declaration.returnType?.type;
      name = declaration.name.name;
    } else if (declaration is MethodDeclaration) {
      returnType = declaration.returnType?.type;
      name = declaration.name.name;
    }

    return returnType != null && hasWidgetType(returnType) && name == 'build';
  }

  String _compileMessage({
    required num lines,
    required Object functionType,
  }) =>
      'Long $functionType. This $functionType contains $lines lines with code.';

  String? _compileRecommendationMessage({
    required num? maximumLines,
    required Object functionType,
  }) =>
      maximumLines != null
          ? "Based on configuration of this package, we don't recommend write a $functionType longer than $maximumLines lines with code."
          : null;

  @Deprecated('Fallback for current behaviour, will be removed in 5.0.0')
  Iterable<Issue> _legacyBehaviour(
    InternalResolvedUnitResult source,
    MapEntry<ScopedFunctionDeclaration, Report> entry,
  ) =>
      entry.value.metrics
          .where((metricValue) =>
              metricValue.metricsId == SourceLinesOfCodeMetric.metricId &&
              metricValue.level == MetricValueLevel.none &&
              metricValue.value > 50)
          .map(
            (metricValue) => createIssue(
              pattern: this,
              location: nodeLocation(
                node: entry.key.declaration,
                source: source,
              ),
              message: _compileMessage(
                lines: metricValue.value,
                functionType: entry.key.type,
              ),
              verboseMessage:
                  'Anti pattern works in deprecated mode. Please configure ${SourceLinesOfCodeMetric.metricId} metric. For detailed information please read documentation.',
            ),
          );
}
