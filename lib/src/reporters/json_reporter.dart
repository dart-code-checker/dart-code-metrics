import 'dart:convert';

import 'package:meta/meta.dart';

import '../config/config.dart';
import '../models/code_issue.dart';
import '../models/design_issue.dart';
import '../models/file_record.dart';
import '../models/report_metric.dart';
import 'reporter.dart';
import 'utility_selector.dart';

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
            ..._report(report.methodsCount, numberOfMethodsKey),
          });
        }),
        ...record.functions.map((key, value) {
          final report = UtilitySelector.functionReport(value, reportConfig);

          return MapEntry(key, {
            ..._report(report.cyclomaticComplexity, cyclomaticComplexityKey),
            ..._report(report.linesOfExecutableCode, linesOfExecutableCodeKey),
            ..._report(report.maintainabilityIndex, 'maintainability-index'),
            ..._report(report.argumentsCount, numberOfArgumentsKey),
            ..._report(report.maximumNestingLevel, maximumNestingKey),
          });
        }),
      },
      'issues': _reportCodeIssue(record.issues),
      'designIssues': _reportDesignIssues(record.designIssues),
      'average-$numberOfArgumentsKey': fileReport.averageArgumentsCount,
      'total-$numberOfArgumentsKey-violations':
          fileReport.argumentsCountViolations,
      'average-$numberOfMethodsKey': fileReport.averageMethodsCount,
      'total-$numberOfMethodsKey-violations': fileReport.methodsCountViolations,
      'total-$linesOfExecutableCodeKey': fileReport.totalLinesOfExecutableCode,
      'total-$linesOfExecutableCodeKey-violations':
          fileReport.linesOfExecutableCodeViolations,
      'average-$maximumNestingKey': fileReport.averageMaximumNestingLevel,
      'total-$maximumNestingKey-violations':
          fileReport.maximumNestingLevelViolations,
    };
  }

  Iterable<Map<String, Object>> _reportCodeIssue(
    Iterable<CodeIssue> issues,
  ) =>
      issues
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
          .toList();

  Iterable<Map<String, Object>> _reportDesignIssues(
    Iterable<DesignIssue> issues,
  ) =>
      issues
          .map((issue) => {
                'patternId': issue.patternId,
                if (issue.patternDocumentation != null)
                  'patternDocumentation': issue.patternDocumentation.toString(),
                'lineNumber': issue.sourceSpan.start.line,
                'columnNumber': issue.sourceSpan.start.column,
                if (issue.sourceSpan.text != null)
                  'problemCode': issue.sourceSpan.text,
                'message': issue.message,
                if (issue.recommendation != null)
                  'recommendation': issue.recommendation,
              })
          .toList();

  Map<String, Object> _report(ReportMetric<num> metric, String metricName) => {
        metricName: metric.value.toInt(),
        '$metricName-violation-level':
            metric.violationLevel.toString().toLowerCase(),
      };
}
