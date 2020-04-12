import 'dart:convert';

import 'package:dart_code_metrics/src/models/component_record.dart';
import 'package:dart_code_metrics/src/models/config.dart';
import 'package:dart_code_metrics/src/models/function_report_metric.dart';
import 'package:dart_code_metrics/src/reporters/reporter.dart';
import 'package:dart_code_metrics/src/reporters/utility_selector.dart';
import 'package:meta/meta.dart';

/// Machine-readable report in JSON format
class JsonReporter implements Reporter {
  final Config reportConfig;

  JsonReporter({@required this.reportConfig});

  @override
  Iterable<String> report(Iterable<ComponentRecord> records) =>
      (records?.isNotEmpty ?? false)
          ? [json.encode(records.map(_analysisRecordToJson).toList())]
          : [];

  Map<String, Object> _analysisRecordToJson(ComponentRecord record) {
    final componentReport =
        UtilitySelector.componentReport(record, reportConfig);
    return {
      'source': record.relativePath,
      'records': record.records.map((key, value) {
        final report = UtilitySelector.functionReport(value, reportConfig);
        return MapEntry(
            key,
            {
              'number-of-arguments': report.argumentsCount,
              'number-of-arguments-violation-level':
                  report.argumentsCountViolationLevel.toString().toLowerCase(),
            }
              ..addAll(
                  _report(report.cyclomaticComplexity, 'cyclomatic-complexity'))
              ..addAll(_report(report.linesOfCode, 'lines-of-code'))
              ..addAll(_report(
                  report.maintainabilityIndex, 'maintainability-index')));
      }),
      'average-number-of-arguments': componentReport.averageArgumentsCount,
      'total-number-of-arguments-violations':
          componentReport.totalArgumentsCountViolations,
    };
  }

  Map<String, Object> _report(
          FunctionReportMetric<num> metric, String metricName) =>
      {
        metricName: metric.value.toInt(),
        '$metricName-violation-level':
            metric.violationLevel.toString().toLowerCase()
      };
}
