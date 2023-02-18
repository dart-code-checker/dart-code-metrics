// ignore_for_file: public_member_api_docs

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/type.dart';

import '../../../../utils/flutter_types_utils.dart';
import '../../../../utils/node_utils.dart';
import '../../lint_utils.dart';
import '../../metrics/metric_utils.dart';
import '../../metrics/metrics_list/source_lines_of_code/source_lines_of_code_metric.dart';
import '../../models/internal_resolved_unit_result.dart';
import '../../models/issue.dart';
import '../../models/report.dart';
import '../../models/scoped_class_declaration.dart';
import '../../models/scoped_function_declaration.dart';
import '../../models/severity.dart';
import '../models/pattern.dart';
import '../pattern_utils.dart';

class LongMethod extends Pattern {
  static const String patternId = 'long-method';

  final int? _sourceLinesOfCodeMetricThreshold;

  @override
  Iterable<String> get dependentMetricIds => [SourceLinesOfCodeMetric.metricId];

  LongMethod({
    Map<String, Object> patternSettings = const {},
    Map<String, Object> metricsThresholds = const {},
  })  : _sourceLinesOfCodeMetricThreshold = readNullableThreshold<int>(
          metricsThresholds,
          SourceLinesOfCodeMetric.metricId,
        ),
        super(
          id: patternId,
          severity: readSeverity(patternSettings, Severity.warning),
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
                if (_sourceLinesOfCodeMetricThreshold != null)
                  ...entry.value.metrics
                      .where((metricValue) =>
                          metricValue.metricsId ==
                              SourceLinesOfCodeMetric.metricId &&
                          metricValue.value >
                              _sourceLinesOfCodeMetricThreshold!)
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
                            maximumLines: _sourceLinesOfCodeMetricThreshold,
                            functionType: entry.key.type,
                          ),
                        ),
                      ),
              ])
          .toList();

  bool _isExcluded(ScopedFunctionDeclaration function) {
    final declaration = function.declaration;
    DartType? returnType;
    String? name;

    if (declaration is FunctionDeclaration) {
      returnType = declaration.returnType?.type;
      name = declaration.name.lexeme;
    } else if (declaration is MethodDeclaration) {
      returnType = declaration.returnType?.type;
      name = declaration.name.lexeme;
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
}
