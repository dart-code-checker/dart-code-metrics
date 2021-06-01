import 'dart:math';

import 'package:quiver/iterables.dart' as quiver;

import '../metrics/metric_utils.dart';
import '../metrics/metrics_list/cyclomatic_complexity/cyclomatic_complexity_metric.dart';
import '../metrics/metrics_list/maximum_nesting_level/maximum_nesting_level_metric.dart';
import '../metrics/metrics_list/number_of_methods_metric.dart';
import '../metrics/metrics_list/number_of_parameters_metric.dart';
import '../metrics/metrics_list/source_lines_of_code/source_lines_of_code_metric.dart';
import '../metrics/metrics_list/weight_of_class_metric.dart';
import '../metrics/models/metric_documentation.dart';
import '../metrics/models/metric_value.dart';
import '../metrics/models/metric_value_level.dart';
import '../models/entity_type.dart';
import '../models/lint_file_report.dart';
import '../models/report.dart';
import 'models/class_metrics_report.dart';
import 'models/file_metrics_report.dart';
import 'models/function_metrics_report.dart';

double log2(num a) => log(a) / ln2;

num sum(Iterable<num> it) => it.fold(0, (a, b) => a + b);

double avg(Iterable<num> it) => it.isNotEmpty ? sum(it) / it.length : 0;

class UtilitySelector {
  static FileMetricsReport analysisReportForRecords(
    Iterable<LintFileReport> records,
  ) =>
      records.map(fileReport).reduce(mergeFileReports);

  static FileMetricsReport fileReport(LintFileReport record) {
    final classMetricsReports = record.classes.values.map(classMetricsReport);
    final functionMetricsReports =
        record.functions.values.map(functionMetricsReport);

    final averageArgumentCount =
        avg(functionMetricsReports.map((r) => r.argumentsCount.value));
    final totalArgumentsCountViolations = functionMetricsReports
        .where((r) => isReportLevel(r.argumentsCount.level))
        .length;

    final averageMaintainabilityIndex =
        avg(functionMetricsReports.map((r) => r.maintainabilityIndex.value));
    final totalMaintainabilityIndexViolations = functionMetricsReports
        .where((r) => isReportLevel(r.maintainabilityIndex.level))
        .length;

    final averageMethodsCount =
        avg(classMetricsReports.map((r) => r.methodsCount.value));
    final totalMethodsCountViolations = classMetricsReports
        .where((r) => isReportLevel(r.methodsCount.level))
        .length;

    final totalCyclomaticComplexity =
        sum(functionMetricsReports.map((r) => r.cyclomaticComplexity.value));
    final totalCyclomaticComplexityViolations = functionMetricsReports
        .where((r) => isReportLevel(r.cyclomaticComplexity.level))
        .length;

    final totalSourceLinesOfCode =
        sum(functionMetricsReports.map((r) => r.sourceLinesOfCode.value));
    final totalSourceLinesOfCodeViolations = functionMetricsReports
        .where((r) => isReportLevel(r.sourceLinesOfCode.level))
        .length;

    final averageMaximumNestingLevel =
        avg(functionMetricsReports.map((r) => r.maximumNestingLevel.value))
            .round();
    final totalMaximumNestingLevelViolations = functionMetricsReports
        .where((r) => isReportLevel(r.maximumNestingLevel.level))
        .length;

    return FileMetricsReport(
      averageArgumentsCount: averageArgumentCount.round(),
      argumentsCountViolations: totalArgumentsCountViolations,
      averageMaintainabilityIndex: averageMaintainabilityIndex,
      maintainabilityIndexViolations: totalMaintainabilityIndexViolations,
      averageMethodsCount: averageMethodsCount.round(),
      methodsCountViolations: totalMethodsCountViolations,
      totalCyclomaticComplexity: totalCyclomaticComplexity.round(),
      cyclomaticComplexityViolations: totalCyclomaticComplexityViolations,
      totalSourceLinesOfCode: totalSourceLinesOfCode.round(),
      sourceLinesOfCodeViolations: totalSourceLinesOfCodeViolations,
      averageMaximumNestingLevel: averageMaximumNestingLevel,
      maximumNestingLevelViolations: totalMaximumNestingLevelViolations,
    );
  }

  static ClassMetricsReport classMetricsReport(Report component) {
    final numberOfMethodsMetric =
        component.metric(NumberOfMethodsMetric.metricId) ??
            _buildMetricValueStub<int>(
              id: NumberOfMethodsMetric.metricId,
              value: 0,
              type: EntityType.classEntity,
            );

    final weightOfClassMetric =
        component.metric(WeightOfClassMetric.metricId) ??
            _buildMetricValueStub<double>(
              id: NumberOfMethodsMetric.metricId,
              value: 0,
              type: EntityType.classEntity,
            );

    return ClassMetricsReport(
      methodsCount: numberOfMethodsMetric as MetricValue<int>,
      weightOfClass: weightOfClassMetric as MetricValue<double>,
    );
  }

  static FunctionMetricsReport functionMetricsReport(Report function) {
    final cyclomaticComplexityMetric =
        function.metric(CyclomaticComplexityMetric.metricId) ??
            _buildMetricValueStub<int>(
              id: CyclomaticComplexityMetric.metricId,
              value: 0,
            );

    final sourceLinesOfCodeMetric =
        function.metric(SourceLinesOfCodeMetric.metricId) ??
            _buildMetricValueStub<int>(
              id: SourceLinesOfCodeMetric.metricId,
              value: 0,
            );

    final maintainabilityIndexMetric =
        function.metric('maintainability-index') ??
            _buildMetricValueStub<double>(
              id: 'maintainability-index',
              value: 100,
            );

    final numberOfParametersMetric =
        function.metric(NumberOfParametersMetric.metricId) ??
            _buildMetricValueStub<int>(
              id: NumberOfParametersMetric.metricId,
              value: 0,
            );

    final maximumNestingLevelMetric =
        function.metric(MaximumNestingLevelMetric.metricId) ??
            _buildMetricValueStub<int>(
              id: MaximumNestingLevelMetric.metricId,
              value: 0,
            );

    return FunctionMetricsReport(
      cyclomaticComplexity: cyclomaticComplexityMetric as MetricValue<int>,
      sourceLinesOfCode: sourceLinesOfCodeMetric as MetricValue<int>,
      maintainabilityIndex: maintainabilityIndexMetric as MetricValue<double>,
      argumentsCount: numberOfParametersMetric as MetricValue<int>,
      maximumNestingLevel: maximumNestingLevelMetric as MetricValue<int>,
    );
  }

  static MetricValueLevel classMetricViolationLevel(
    ClassMetricsReport report,
  ) =>
      report.methodsCount.level;

  static MetricValueLevel functionMetricViolationLevel(
    FunctionMetricsReport report,
  ) =>
      quiver.max([
        report.cyclomaticComplexity.level,
        report.sourceLinesOfCode.level,
        report.maintainabilityIndex.level,
        report.argumentsCount.level,
        report.maximumNestingLevel.level,
      ])!;

  static MetricValueLevel maxViolationLevel(Iterable<LintFileReport> records) =>
      quiver.max(records
          .expand(
            (fileRecord) =>
                fileRecord.functions.values.map(functionMetricsReport),
          )
          .map(functionMetricViolationLevel))!;

  static FileMetricsReport mergeFileReports(
    FileMetricsReport lhs,
    FileMetricsReport rhs,
  ) =>
      FileMetricsReport(
        averageArgumentsCount:
            ((lhs.averageArgumentsCount + rhs.averageArgumentsCount) / 2)
                .round(),
        argumentsCountViolations:
            lhs.argumentsCountViolations + rhs.argumentsCountViolations,
        averageMaintainabilityIndex: (lhs.averageMaintainabilityIndex +
                rhs.averageMaintainabilityIndex) /
            2,
        maintainabilityIndexViolations: lhs.maintainabilityIndexViolations +
            rhs.maintainabilityIndexViolations,
        averageMethodsCount:
            ((lhs.averageMethodsCount + rhs.averageMethodsCount) / 2).round(),
        methodsCountViolations:
            lhs.methodsCountViolations + rhs.methodsCountViolations,
        totalCyclomaticComplexity:
            lhs.totalCyclomaticComplexity + rhs.totalCyclomaticComplexity,
        cyclomaticComplexityViolations: lhs.cyclomaticComplexityViolations +
            rhs.cyclomaticComplexityViolations,
        totalSourceLinesOfCode:
            lhs.totalSourceLinesOfCode + rhs.totalSourceLinesOfCode,
        sourceLinesOfCodeViolations:
            lhs.sourceLinesOfCodeViolations + rhs.sourceLinesOfCodeViolations,
        averageMaximumNestingLevel:
            ((lhs.averageMaximumNestingLevel + rhs.averageMaximumNestingLevel) /
                    2)
                .round(),
        maximumNestingLevelViolations: lhs.maximumNestingLevelViolations +
            rhs.maximumNestingLevelViolations,
      );
}

MetricValue<T> _buildMetricValueStub<T>({
  required String id,
  required T value,
  EntityType type = EntityType.methodEntity,
  MetricValueLevel level = MetricValueLevel.none,
}) =>
    MetricValue<T>(
      metricsId: id,
      documentation: MetricDocumentation(
        name: id,
        shortName: id.toUpperCase(),
        brief: 'brief $id',
        measuredType: type,
        examples: const [],
      ),
      value: value,
      level: level,
      comment: '',
    );
