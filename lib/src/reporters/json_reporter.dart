import 'dart:convert';

import 'package:dart_code_metrics/src/models/config.dart';
import 'package:dart_code_metrics/src/models/file_record.dart';
import 'package:dart_code_metrics/src/models/report_metric.dart';
import 'package:dart_code_metrics/src/reporters/reporter.dart';
import 'package:dart_code_metrics/src/reporters/utility_selector.dart';
import 'package:meta/meta.dart';

/// Machine-readable report in JSON format
class JsonReporter implements Reporter {
  final Config reportConfig;

  JsonReporter({@required this.reportConfig});

  @override
  Iterable<String> report(Iterable<FileRecord> records) =>
      (records?.isNotEmpty ?? false)
          ? [json.encode(records.map(_analysisRecordToJson).toList())]
          : [];

  Map<String, Object> _analysisRecordToJson(FileRecord record) {
    final fileReport = UtilitySelector.fileReport(record, reportConfig);

    return {
      'source': record.relativePath,
      'records': {
        ...record.components.map((key, value) {
          final report = UtilitySelector.componentReport(value, reportConfig);

          return MapEntry(key, {
            ..._report(report.methodsCount, 'number-of-methods'),
          });
        }),
        ...record.functions.map((key, value) {
          final report = UtilitySelector.functionReport(value, reportConfig);

          return MapEntry(key, {
            ..._report(report.cyclomaticComplexity, 'cyclomatic-complexity'),
            ..._report(report.linesOfCode, 'lines-of-code'),
            ..._report(report.maintainabilityIndex, 'maintainability-index'),
            ..._report(report.argumentsCount, 'number-of-arguments'),
          });
        }),
      },
      'issues': record.issues
          .map((issue) => {
                'severity': issue.severity.value,
                'ruleId': issue.ruleId,
                if (issue.ruleDocumentation != null)
                  'ruleDocumentation': issue.ruleDocumentation.toString(),
                'lineNumber': issue.sourceSpan.start.line,
                'columnNumber': issue.sourceSpan.start.column,
                if (issue.sourceSpan.text != null)
                  'problemCode': issue.sourceSpan.text,
                'message': issue.message,
                if (issue.correction != null) 'correction': issue.correction,
                if (issue.correctionComment != null)
                  'correctionComment': issue.correctionComment,
              })
          .toList(),
      'average-number-of-arguments': fileReport.averageArgumentsCount,
      'total-number-of-arguments-violations':
          fileReport.totalArgumentsCountViolations,
      'average-number-of-methods': fileReport.averageMethodsCount,
      'total-number-of-methods-violations':
          fileReport.totalMethodsCountViolations,
    };
  }

  Map<String, Object> _report(ReportMetric<num> metric, String metricName) => {
        metricName: metric.value.toInt(),
        '$metricName-violation-level':
            metric.violationLevel.toString().toLowerCase(),
      };
}
