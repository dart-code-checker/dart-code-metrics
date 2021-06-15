import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/type.dart';

import '../../../../utils/node_utils.dart';
import '../../metrics/metric_utils.dart';
import '../../metrics/metrics_list/source_lines_of_code/source_code_visitor.dart';
import '../../metrics/metrics_list/source_lines_of_code/source_lines_of_code_metric.dart';
import '../../models/entity_type.dart';
import '../../models/internal_resolved_unit_result.dart';
import '../../models/issue.dart';
import '../../models/scoped_function_declaration.dart';
import '../../rules/flutter_rule_utils.dart';
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
        readThreshold<int>(metricsConfig, SourceLinesOfCodeMetric.metricId, 50);

    return functions
        .where((function) => !_isExcluded(function))
        .expand<Issue>((function) {
      final visitor = SourceCodeVisitor(source.lineInfo);
      function.declaration.visitChildren(visitor);

      return [
        if (visitor.linesWithCode.length > threshold)
          createIssue(
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
          ),
      ];
    }).toList();
  }

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
    required int lines,
    required Object functionType,
  }) =>
      'Long $functionType. This $functionType contains $lines lines with code.';

  String _compileRecommendationMessage({
    required int maximumLines,
    required Object functionType,
  }) =>
      "Based on configuration of this package, we don't recommend write a $functionType longer than $maximumLines lines with code.";
}
