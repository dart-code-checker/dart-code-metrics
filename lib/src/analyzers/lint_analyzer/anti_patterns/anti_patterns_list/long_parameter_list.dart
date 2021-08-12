import '../../../../utils/node_utils.dart';
import '../../metrics/metric_utils.dart';
import '../../metrics/metrics_list/number_of_parameters_metric.dart';
import '../../models/entity_type.dart';
import '../../models/function_type.dart';
import '../../models/internal_resolved_unit_result.dart';
import '../../models/issue.dart';
import '../../models/scoped_function_declaration.dart';
import '../models/obsolete_pattern.dart';
import '../models/pattern_documentation.dart';
import '../pattern_utils.dart';

class LongParameterList extends ObsoletePattern {
  static const String patternId = 'long-parameter-list';

  LongParameterList()
      : super(
          id: patternId,
          documentation: const PatternDocumentation(
            name: 'Long Parameter List',
            brief:
                'Long parameter lists are difficult to understand and use. Wrapping them into an object allows grouping parameters and change transferred data only by the object modification.',
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
        readThreshold<int>(metricsConfig, NumberOfParametersMetric.metricId, 4);

    return functions
        .where((function) => getArgumentsCount(function) > threshold)
        .map((function) => createIssue(
              pattern: this,
              location: nodeLocation(
                node: function.declaration,
                source: source,
              ),
              message: _compileMessage(
                args: getArgumentsCount(function),
                functionType: function.type,
              ),
              verboseMessage: _compileRecommendationMessage(
                maximumArguments: threshold,
                functionType: function.type,
              ),
            ))
        .toList();
  }

  String _compileMessage({
    required int args,
    required FunctionType functionType,
  }) =>
      'Long Parameter List. This $functionType require $args arguments.';

  String _compileRecommendationMessage({
    required int maximumArguments,
    required FunctionType functionType,
  }) =>
      "Based on configuration of this package, we don't recommend writing a $functionType with argument count more than $maximumArguments.";
}
