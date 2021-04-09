import 'dart:convert';
import 'dart:io';

import 'package:meta/meta.dart';

import '../../metrics/cyclomatic_complexity/cyclomatic_complexity_metric.dart';
import '../../metrics/maximum_nesting_level/maximum_nesting_level_metric.dart';
import '../../metrics/number_of_methods_metric.dart';
import '../../metrics/number_of_parameters_metric.dart';
import '../../models/file_report.dart';
import '../../models/issue.dart';
import '../../models/metric_value.dart';
import '../../reporters/reporter.dart';
import '../constants.dart';
import 'utility_selector.dart';

/// Machine-readable report in JSON format
@immutable
class JsonReporter implements Reporter {
  final IOSink _output;

  const JsonReporter(this._output);

  @override
  Future<void> report(Iterable<FileReport> records) async {
    if (records.isEmpty) {
      return;
    }

    final encodedReport =
        json.encode(records.map(_analysisRecordToJson).toList());

    _output.write(encodedReport);
  }

  Map<String, Object> _analysisRecordToJson(FileReport record) {
    final fileReport = UtilitySelector.fileReport(record);

    return {
      'source': record.relativePath,
      'records': {
        ...record.classes.map((key, value) {
          final report = UtilitySelector.componentReport(value);

          return MapEntry(key, {
            ..._report(report.methodsCount, NumberOfMethodsMetric.metricId),
          });
        }),
        ...record.functions.map((key, value) {
          final report = UtilitySelector.functionReport(value);

          return MapEntry(key, {
            ..._report(
              report.cyclomaticComplexity,
              CyclomaticComplexityMetric.metricId,
            ),
            ..._report(report.linesOfExecutableCode, linesOfExecutableCodeKey),
            ..._report(report.maintainabilityIndex, 'maintainability-index'),
            ..._report(
              report.argumentsCount,
              NumberOfParametersMetric.metricId,
            ),
            ..._report(
              report.maximumNestingLevel,
              MaximumNestingLevelMetric.metricId,
            ),
          });
        }),
      },
      'issues': _reportCodeIssue(record.issues),
      'designIssues': _reportDesignIssues(record.antiPatternCases),
      'average-${NumberOfParametersMetric.metricId}':
          fileReport.averageArgumentsCount,
      'total-${NumberOfParametersMetric.metricId}-violations':
          fileReport.argumentsCountViolations,
      'average-${NumberOfMethodsMetric.metricId}':
          fileReport.averageMethodsCount,
      'total-${NumberOfMethodsMetric.metricId}-violations':
          fileReport.methodsCountViolations,
      'total-$linesOfExecutableCodeKey': fileReport.totalLinesOfExecutableCode,
      'total-$linesOfExecutableCodeKey-violations':
          fileReport.linesOfExecutableCodeViolations,
      'average-${MaximumNestingLevelMetric.metricId}':
          fileReport.averageMaximumNestingLevel,
      'total-${MaximumNestingLevelMetric.metricId}-violations':
          fileReport.maximumNestingLevelViolations,
    };
  }

  Iterable<Map<String, Object>> _reportCodeIssue(
    Iterable<Issue> issues,
  ) =>
      issues
          .map((issue) => {
                'severity': issue.severity.toString(),
                'ruleId': issue.ruleId,
                'ruleDocumentation': issue.documentation.toString(),
                'lineNumber': issue.location.start.line,
                'columnNumber': issue.location.start.column,
                'problemCode': issue.location.text,
                'message': issue.message,
                if (issue.suggestion != null)
                  'correction': issue.suggestion!.replacement,
                if (issue.suggestion != null)
                  'correctionComment': issue.suggestion!.comment,
              })
          .toList();

  Iterable<Map<String, Object>> _reportDesignIssues(
    Iterable<Issue> issues,
  ) =>
      issues
          .map((issue) => {
                'patternId': issue.ruleId,
                'patternDocumentation': issue.documentation.toString(),
                'lineNumber': issue.location.start.line,
                'columnNumber': issue.location.start.column,
                'problemCode': issue.location.text,
                'message': issue.message,
                if (issue.verboseMessage != null)
                  'recommendation': issue.verboseMessage!,
              })
          .toList();

  Map<String, Object> _report(MetricValue<num> metric, String metricName) => {
        metricName: metric.value.toInt(),
        '$metricName-violation-level': metric.level.toString(),
      };
}
