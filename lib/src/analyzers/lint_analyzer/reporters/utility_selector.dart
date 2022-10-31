import 'package:collection/collection.dart';

import '../metrics/metric_utils.dart';
import '../metrics/metrics_list/cyclomatic_complexity/cyclomatic_complexity_metric.dart';
import '../metrics/metrics_list/maintainability_index_metric.dart';
import '../metrics/metrics_list/maximum_nesting_level/maximum_nesting_level_metric.dart';
import '../metrics/metrics_list/number_of_parameters_metric.dart';
import '../metrics/metrics_list/source_lines_of_code/source_lines_of_code_metric.dart';
import '../metrics/metrics_list/technical_debt/technical_debt_metric.dart';
import '../metrics/models/metric_documentation.dart';
import '../metrics/models/metric_value.dart';
import '../metrics/models/metric_value_level.dart';
import '../models/entity_type.dart';
import '../models/lint_file_report.dart';
import '../models/report.dart';
import 'reporters_list/html/models/file_metrics_report.dart';
import 'reporters_list/html/models/function_metrics_report.dart';

double avg(Iterable<num> it) => it.isNotEmpty ? it.sum / it.length : 0;

class UtilitySelector {
  static FileMetricsReport analysisReportForRecords(
    Iterable<LintFileReport> records,
  ) =>
      records.map(fileReport).reduce(mergeFileReports);

  static FileMetricsReport fileReport(LintFileReport record) {
    final functionMetricsReports =
        record.functions.values.map(_functionMetricsReport);

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

    final totalCyclomaticComplexity =
        functionMetricsReports.map((r) => r.cyclomaticComplexity.value).sum;
    final totalCyclomaticComplexityViolations = functionMetricsReports
        .where((r) => isReportLevel(r.cyclomaticComplexity.level))
        .length;

    final totalSourceLinesOfCode =
        functionMetricsReports.map((r) => r.sourceLinesOfCode.value).sum;
    final totalSourceLinesOfCodeViolations = functionMetricsReports
        .where((r) => isReportLevel(r.sourceLinesOfCode.level))
        .length;

    final averageMaximumNestingLevel =
        avg(functionMetricsReports.map((r) => r.maximumNestingLevel.value))
            .round();
    final totalMaximumNestingLevelViolations = functionMetricsReports
        .where((r) => isReportLevel(r.maximumNestingLevel.level))
        .length;

    final technicalDeptMetric =
        record.file?.metric(TechnicalDebtMetric.metricId);
    final technicalDebt = technicalDeptMetric?.value.toDouble() ?? 0.0;
    final technicalDebtViolations = record.file?.metrics
            .where((value) =>
                value.metricsId == TechnicalDebtMetric.metricId &&
                isReportLevel(value.level))
            .length ??
        0;
    final technicalDebtUnitType = technicalDeptMetric?.unitType;

    return FileMetricsReport(
      averageArgumentsCount: averageArgumentCount.round(),
      argumentsCountViolations: totalArgumentsCountViolations,
      averageMaintainabilityIndex: averageMaintainabilityIndex,
      maintainabilityIndexViolations: totalMaintainabilityIndexViolations,
      totalCyclomaticComplexity: totalCyclomaticComplexity,
      cyclomaticComplexityViolations: totalCyclomaticComplexityViolations,
      totalSourceLinesOfCode: totalSourceLinesOfCode,
      sourceLinesOfCodeViolations: totalSourceLinesOfCodeViolations,
      averageMaximumNestingLevel: averageMaximumNestingLevel,
      maximumNestingLevelViolations: totalMaximumNestingLevelViolations,
      technicalDebt: technicalDebt,
      technicalDebtViolations: technicalDebtViolations,
      technicalDebtUnitType: technicalDebtUnitType,
    );
  }

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
        technicalDebt: lhs.technicalDebt + rhs.technicalDebt,
        technicalDebtViolations:
            lhs.technicalDebtViolations + rhs.technicalDebtViolations,
        technicalDebtUnitType:
            lhs.technicalDebtUnitType ?? rhs.technicalDebtUnitType,
      );
}

MetricValue<T> _buildMetricValueStub<T extends num>({
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
        measuredType: type,
        recommendedThreshold: 0,
      ),
      value: value,
      level: level,
      comment: '',
    );

FunctionMetricsReport _functionMetricsReport(Report function) {
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

  final maintainabilityIndexMetric = function.metric('maintainability-index') ??
      _buildMetricValueStub<int>(
        id: MaintainabilityIndexMetric.metricId,
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
    maintainabilityIndex: maintainabilityIndexMetric as MetricValue<int>,
    argumentsCount: numberOfParametersMetric as MetricValue<int>,
    maximumNestingLevel: maximumNestingLevelMetric as MetricValue<int>,
  );
}
