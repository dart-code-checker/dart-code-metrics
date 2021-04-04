// ignore_for_file: long-method
import 'dart:math';

import 'package:quiver/iterables.dart' as quiver;

import '../../metrics/cyclomatic_complexity/cyclomatic_complexity_metric.dart';
import '../../metrics/maximum_nesting_level/maximum_nesting_level_metric.dart';
import '../../metrics/number_of_methods_metric.dart';
import '../../metrics/number_of_parameters_metric.dart';
import '../../metrics/weight_of_class_metric.dart';
import '../../models/metric_value.dart';
import '../../models/metric_value_level.dart';
import '../../models/report.dart';
import '../../utils/metric_utils.dart';
import '../config/config.dart' as metrics;
import '../models/component_report.dart';
import '../models/file_record.dart';
import '../models/file_report.dart' as metrics;
import '../models/function_record.dart';
import '../models/function_report.dart' as metrics;

double log2(num a) => log(a) / ln2;

num sum(Iterable<num> it) => it.fold(0, (a, b) => a + b);

double avg(Iterable<num> it) => it.isNotEmpty ? sum(it) / it.length : 0;

class UtilitySelector {
  static metrics.FileReport analysisReportForRecords(
    Iterable<FileRecord> records,
  ) =>
      records.map(fileReport).reduce(mergeFileReports);

  static metrics.FileReport fileReport(
    FileRecord record,
  ) {
    final componentReports = record.classes.values.map(componentReport);
    final functionReports = record.functions.values.map(functionReport);

    final averageArgumentCount =
        avg(functionReports.map((r) => r.argumentsCount.value));
    final totalArgumentsCountViolations = functionReports
        .where((r) => isReportLevel(r.argumentsCount.level))
        .length;

    final averageMaintainabilityIndex =
        avg(functionReports.map((r) => r.maintainabilityIndex.value));
    final totalMaintainabilityIndexViolations = functionReports
        .where((r) => isReportLevel(r.maintainabilityIndex.level))
        .length;

    final averageMethodsCount =
        avg(componentReports.map((r) => r.methodsCount.value));
    final totalMethodsCountViolations = componentReports
        .where((r) => isReportLevel(r.methodsCount.level))
        .length;

    final totalCyclomaticComplexity =
        sum(functionReports.map((r) => r.cyclomaticComplexity.value));
    final totalCyclomaticComplexityViolations = functionReports
        .where((r) => isReportLevel(r.cyclomaticComplexity.level))
        .length;

    final totalLinesOfExecutableCode =
        sum(functionReports.map((r) => r.linesOfExecutableCode.value));
    final totalLinesOfExecutableCodeViolations = functionReports
        .where((r) => isReportLevel(r.linesOfExecutableCode.level))
        .length;

    final averageMaximumNestingLevel =
        avg(functionReports.map((r) => r.maximumNestingLevel.value)).round();
    final totalMaximumNestingLevelViolations = functionReports
        .where((r) => isReportLevel(r.maximumNestingLevel.level))
        .length;

    return metrics.FileReport(
      averageArgumentsCount: averageArgumentCount.round(),
      argumentsCountViolations: totalArgumentsCountViolations,
      averageMaintainabilityIndex: averageMaintainabilityIndex,
      maintainabilityIndexViolations: totalMaintainabilityIndexViolations,
      averageMethodsCount: averageMethodsCount.round(),
      methodsCountViolations: totalMethodsCountViolations,
      totalCyclomaticComplexity: totalCyclomaticComplexity.round(),
      cyclomaticComplexityViolations: totalCyclomaticComplexityViolations,
      totalLinesOfExecutableCode: totalLinesOfExecutableCode.round(),
      linesOfExecutableCodeViolations: totalLinesOfExecutableCodeViolations,
      averageMaximumNestingLevel: averageMaximumNestingLevel,
      maximumNestingLevelViolations: totalMaximumNestingLevelViolations,
    );
  }

  static ComponentReport componentReport(Report component) => ComponentReport(
        methodsCount: component.metric(NumberOfMethodsMetric.metricId)
            as MetricValue<int>,
        weightOfClass: component.metric(WeightOfClassMetric.metricId)
            as MetricValue<double>,
      );

  static metrics.FunctionReport functionReport(FunctionRecord function) =>
      metrics.FunctionReport(
        cyclomaticComplexity: function
            .metric(CyclomaticComplexityMetric.metricId) as MetricValue<int>,
        linesOfExecutableCode: function.metric(metrics.linesOfExecutableCodeKey)
            as MetricValue<int>,
        maintainabilityIndex:
            function.metric('maintainability-index') as MetricValue<double>,
        argumentsCount: function.metric(NumberOfParametersMetric.metricId)
            as MetricValue<int>,
        maximumNestingLevel: function.metric(MaximumNestingLevelMetric.metricId)
            as MetricValue<int>,
      );

  static MetricValueLevel componentViolationLevel(ComponentReport report) =>
      report.methodsCount.level;

  static MetricValueLevel functionViolationLevel(
    metrics.FunctionReport report,
  ) =>
      quiver.max([
        report.cyclomaticComplexity.level,
        report.linesOfExecutableCode.level,
        report.maintainabilityIndex.level,
        report.argumentsCount.level,
        report.maximumNestingLevel.level,
      ])!;

  static MetricValueLevel maxViolationLevel(
    Iterable<FileRecord> records,
    metrics.Config config,
  ) =>
      quiver.max(records
          .expand(
            (fileRecord) => fileRecord.functions.values.map(functionReport),
          )
          .map(functionViolationLevel))!;

  static metrics.FileReport mergeFileReports(
    metrics.FileReport lhs,
    metrics.FileReport rhs,
  ) =>
      metrics.FileReport(
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
        totalLinesOfExecutableCode:
            lhs.totalLinesOfExecutableCode + rhs.totalLinesOfExecutableCode,
        linesOfExecutableCodeViolations: lhs.linesOfExecutableCodeViolations +
            rhs.linesOfExecutableCodeViolations,
        averageMaximumNestingLevel:
            ((lhs.averageMaximumNestingLevel + rhs.averageMaximumNestingLevel) /
                    2)
                .round(),
        maximumNestingLevelViolations: lhs.maximumNestingLevelViolations +
            rhs.maximumNestingLevelViolations,
      );
}
