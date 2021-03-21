// ignore_for_file: public_member_api_docs
import 'dart:convert';

import 'package:code_checker/metrics.dart';
import 'package:code_checker/rules.dart';
import 'package:meta/meta.dart';

import '../config/config.dart';
import '../models/file_record.dart';
import 'reporter.dart';
import 'utility_selector.dart';

/// Machine-readable report in JSON format
class JsonReporter implements Reporter {
  final Config reportConfig;

  JsonReporter({@required this.reportConfig});

  @override
  Future<Iterable<String>> report(Iterable<FileRecord> records) async =>
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
    Iterable<Issue> issues,
  ) =>
      issues
          .map((issue) => {
                'severity': issue.severity.toString(),
                'ruleId': issue.ruleId,
                if (issue.documentation != null)
                  'ruleDocumentation': issue.documentation.toString(),
                'lineNumber': issue.location.start.line,
                'columnNumber': issue.location.start.column,
                if (issue.location.text != null)
                  'problemCode': issue.location.text,
                'message': issue.message,
                if (issue.suggestion != null)
                  'correction': issue.suggestion.replacement,
                if (issue.suggestion != null)
                  'correctionComment': issue.suggestion.comment,
              })
          .toList();

  Iterable<Map<String, Object>> _reportDesignIssues(
    Iterable<Issue> issues,
  ) =>
      issues
          .map((issue) => {
                'patternId': issue.ruleId,
                if (issue.documentation != null)
                  'patternDocumentation': issue.documentation.toString(),
                'lineNumber': issue.location.start.line,
                'columnNumber': issue.location.start.column,
                if (issue.location.text != null)
                  'problemCode': issue.location.text,
                'message': issue.message,
                if (issue.verboseMessage != null)
                  'recommendation': issue.verboseMessage,
              })
          .toList();

  Map<String, Object> _report(MetricValue<num> metric, String metricName) => {
        metricName: metric.value.toInt(),
        '$metricName-violation-level': metric.level.toString(),
      };
}
