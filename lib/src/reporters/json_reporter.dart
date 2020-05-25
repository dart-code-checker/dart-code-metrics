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
        return MapEntry(key, {
          ..._report(report.cyclomaticComplexity, 'cyclomatic-complexity'),
          ..._report(report.linesOfCode, 'lines-of-code'),
          ..._report(report.maintainabilityIndex, 'maintainability-index'),
          ..._report(report.argumentsCount, 'number-of-arguments'),
        });
      }),
      'issues': record.issues
          .map((issue) => {
                'severity': issue.severity.toString().split('.').last,
                'ruleId': issue.ruleId,
                if (issue.ruleDocumentationUri != null)
                  'ruleDocumentationUrl': issue.ruleDocumentationUri.toString(),
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
