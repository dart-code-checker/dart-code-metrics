import '../../config/analysis_options.dart' as modern;
import '../../config/config.dart';
import '../../metrics/cyclomatic_complexity/cyclomatic_complexity_metric.dart';
import '../../metrics/maximum_nesting_level/maximum_nesting_level_metric.dart';
import '../../metrics/number_of_methods_metric.dart';
import '../../metrics/number_of_parameters_metric.dart';
import '../../metrics/weight_of_class_metric.dart';
import '../utils/object_extensions.dart';
import 'config.dart' as metrics;

// Documentation about customizing static analysis located at https://dart.dev/guides/language/analysis-options

const _rootKey = 'dart_code_metrics';

/// Class representing options in `analysis_options.yaml`.

class AnalysisOptions extends Config {
  final metrics.Config metricsConfig;

  const AnalysisOptions({
    required Iterable<String> excludePatterns,
    required Iterable<String> excludeForMetricsPatterns,
    required Map<String, Object> metrics,
    required Map<String, Map<String, Object>> rules,
    required Map<String, Map<String, Object>> antiPatterns,
    required this.metricsConfig,
  }) : super(
          excludePatterns: excludePatterns,
          excludeForMetricsPatterns: excludeForMetricsPatterns,
          metrics: metrics,
          rules: rules,
          antiPatterns: antiPatterns,
        );

  factory AnalysisOptions.fromModernAnalysisOptions(
    modern.AnalysisOptions options,
  ) =>
      AnalysisOptions(
        excludePatterns: options.readIterableOfString(['analyzer', 'exclude']),
        excludeForMetricsPatterns:
            options.readIterableOfString([_rootKey, 'metrics-exclude']),
        metrics: options.readMap([_rootKey, 'metrics']),
        metricsConfig: _readMetricsConfig(options),
        rules: options.readMapOfMap([_rootKey, 'rules']),
        antiPatterns: options.readMapOfMap([_rootKey, 'anti-patterns']),
      );
}

metrics.Config _readMetricsConfig(modern.AnalysisOptions options) {
  final metricsOptions = options.readMap([_rootKey, 'metrics']);
  if (metricsOptions is Map<String, Object>) {
    return metrics.Config(
      cyclomaticComplexityWarningLevel:
          metricsOptions[CyclomaticComplexityMetric.metricId]
                  ?.as<int>(metrics.cyclomaticComplexityDefaultWarningLevel) ??
              metrics.cyclomaticComplexityDefaultWarningLevel,
      linesOfExecutableCodeWarningLevel:
          metricsOptions[metrics.linesOfExecutableCodeKey]
                  ?.as<int>(metrics.linesOfExecutableCodeDefaultWarningLevel) ??
              metrics.linesOfExecutableCodeDefaultWarningLevel,
      numberOfParametersWarningLevel:
          metricsOptions[NumberOfParametersMetric.metricId]
                  ?.as<int>(metrics.numberOfParametersDefaultWarningLevel) ??
              metrics.numberOfParametersDefaultWarningLevel,
      numberOfMethodsWarningLevel:
          metricsOptions[NumberOfMethodsMetric.metricId]
                  ?.as<int>(metrics.numberOfMethodsDefaultWarningLevel) ??
              metrics.numberOfMethodsDefaultWarningLevel,
      maximumNestingWarningLevel:
          metricsOptions[MaximumNestingLevelMetric.metricId]
                  ?.as<int>(metrics.maximumNestingDefaultWarningLevel) ??
              metrics.maximumNestingDefaultWarningLevel,
      weightOfClassWarningLevel: metricsOptions[WeightOfClassMetric.metricId]
              ?.as<double>(metrics.weightOfClassDefaultWarningLevel) ??
          metrics.weightOfClassDefaultWarningLevel,
    );
  }

  return const metrics.Config();
}
