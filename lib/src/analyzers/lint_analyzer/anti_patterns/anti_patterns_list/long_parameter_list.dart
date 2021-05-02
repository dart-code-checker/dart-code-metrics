import '../../../models/function_type.dart';
import '../../../models/internal_resolved_unit_result.dart';
import '../../../models/issue.dart';
import '../../../models/scoped_function_declaration.dart';
import '../../metrics/metric_utils.dart';
import '../../metrics/metrics_list/number_of_parameters_metric.dart';
import '../../metrics_analyzer_utils.dart';
import '../models/obsolete_pattern.dart';
import '../pattern_utils.dart' as utils;

class LongParameterList extends ObsoletePattern {
  static const String patternId = 'long-parameter-list';
  static const _documentationUrl = 'https://git.io/JUGrU';

  LongParameterList()
      : super(id: patternId, documentationUrl: Uri.parse(_documentationUrl));

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
        .map((function) => utils.createIssue(
              this,
              _compileMessage(
                args: getArgumentsCount(function),
                functionType: function.type,
              ),
              _compileRecommendationMessage(
                maximumArguments: threshold,
                functionType: function.type,
              ),
              source,
              function.declaration,
            ))
        .toList();
  }

  String _compileMessage({required int args, FunctionType? functionType}) =>
      'Long Parameter List. This ${functionType.toString().toLowerCase()} require $args arguments.';

  String _compileRecommendationMessage({
    required int maximumArguments,
    FunctionType? functionType,
  }) =>
      "Based on configuration of this package, we don't recommend writing a ${functionType.toString().toLowerCase()} with argument count more than $maximumArguments.";
}
