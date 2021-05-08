import '../../../../utils/node_utils.dart';
import '../../../models/entity_type.dart';
import '../../../models/function_type.dart';
import '../../../models/internal_resolved_unit_result.dart';
import '../../../models/issue.dart';
import '../../../models/scoped_function_declaration.dart';
import '../../constants.dart';
import '../../metrics/metric_utils.dart';
import '../../metrics/metrics_list/source_lines_of_code/source_code_visitor.dart';
import '../../metrics/metrics_list/source_lines_of_code/source_lines_of_code_metric.dart';
import '../models/obsolete_pattern.dart';
import '../models/pattern_documentation.dart';
import '../pattern_utils.dart';

class LongMethod extends ObsoletePattern {
  static const String patternId = 'long-method';

  LongMethod()
      : super(
          id: patternId,
          documentation: const PatternDocumentation(
            name: 'Long Method',
            brief:
                'Long blocks of code are difficult to reuse and understand because they are usually responsible for more than one thing. Separating those to several short ones with proper names helps you reuse your code and understand it better without reading methods body.',
            supportedType: EntityType.methodEntity,
          ),
        );

  @override
  Iterable<Issue> legacyCheck(
    InternalResolvedUnitResult source,
    Iterable<ScopedFunctionDeclaration> functions,
    Map<String, Object> metricsConfig,
  ) {
    final threshold =
        metricsConfig.containsKey(SourceLinesOfCodeMetric.metricId)
            ? readThreshold<int>(
                metricsConfig,
                SourceLinesOfCodeMetric.metricId,
                linesOfExecutableCodeDefaultWarningLevel,
              )
            : readThreshold<int>(
                metricsConfig,
                linesOfExecutableCodeKey,
                linesOfExecutableCodeDefaultWarningLevel,
              );

    final issues = <Issue>[];

    for (final function in functions) {
      final visitor = SourceCodeVisitor(source.lineInfo);
      function.declaration.visitChildren(visitor);

      if (visitor.linesWithCode.length > threshold) {
        issues.add(createIssue(
          pattern: this,
          location: nodeLocation(
            node: function.declaration,
            source: source,
          ),
          message: _compileMessage(
            lines: visitor.linesWithCode.length,
            functionType: function.type,
          ),
          verboseMessage: _compileRecommendationMessage(
            maximumLines: threshold,
            functionType: function.type,
          ),
        ));
      }
    }

    return issues;
  }

  String _compileMessage({required int lines, FunctionType? functionType}) =>
      'Long $functionType. This ${functionType.toString().toLowerCase()} contains $lines lines with executable code.';

  String _compileRecommendationMessage({
    required int maximumLines,
    FunctionType? functionType,
  }) =>
      "Based on configuration of this package, we don't recommend write a ${functionType.toString().toLowerCase()} longer than $maximumLines lines with executable code.";
}
