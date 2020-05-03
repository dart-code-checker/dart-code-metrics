import 'package:ansicolor/ansicolor.dart';
import 'package:dart_code_metrics/src/models/code_issue_severity.dart';
import 'package:dart_code_metrics/src/models/component_record.dart';
import 'package:dart_code_metrics/src/models/config.dart';
import 'package:dart_code_metrics/src/models/function_report_metric.dart';
import 'package:dart_code_metrics/src/models/violation_level.dart';
import 'package:dart_code_metrics/src/reporters/reporter.dart';
import 'package:dart_code_metrics/src/reporters/utility_selector.dart';
import 'package:meta/meta.dart';

/// Plain terminal reporter
class ConsoleReporter implements Reporter {
  final Config reportConfig;

  /// If true will report info about all files even if they're not above warning threshold
  final bool reportAll;

  final _colorPens = {
    ViolationLevel.alarm: AnsiPen()..red(),
    ViolationLevel.warning: AnsiPen()..yellow(),
    ViolationLevel.noted: AnsiPen()..blue(),
    ViolationLevel.none: AnsiPen()..white(),
  };

  final _humanReadableLabel = {
    ViolationLevel.alarm: 'ALARM',
    ViolationLevel.warning: 'WARNING',
    ViolationLevel.noted: 'NOTED',
    ViolationLevel.none: '',
  };

  final _severityColors = {
    CodeIssueSeverity.style: AnsiPen()..blue(),
  };

  final _severityHumanReadable = {
    CodeIssueSeverity.style: 'Style',
  };

  ConsoleReporter({@required this.reportConfig, this.reportAll = false});

  @override
  Iterable<String> report(Iterable<ComponentRecord> records) {
    if (records?.isEmpty ?? true) {
      return [];
    }

    final reportStrings = <String>[];

    for (final analysisRecord in records) {
      final lines = <String>[];

      analysisRecord.records.forEach((source, functionReport) {
        final report =
            UtilitySelector.functionReport(functionReport, reportConfig);
        final violationLevel = UtilitySelector.functionViolationLevel(report);

        if (reportAll || UtilitySelector.isIssueLevel(violationLevel)) {
          final violations = [
            if (reportAll || _isNeedToReport(report.cyclomaticComplexity))
              _report(report.cyclomaticComplexity, 'cyclomatic complexity'),
            if (reportAll || _isNeedToReport(report.linesOfCode))
              _report(report.linesOfCode, 'lines of code'),
            if (reportAll || _isNeedToReport(report.maintainabilityIndex))
              _report(report.maintainabilityIndex, 'maintainability index'),
            if (reportAll || _isNeedToReport(report.argumentsCount))
              _report(report.argumentsCount, 'number of arguments'),
          ];
          lines.add(
              '${_colorPens[violationLevel](_humanReadableLabel[violationLevel]?.padRight(8))}$source - ${violations.join(', ')}');
        }
      });

      for (final issue in analysisRecord.issues) {
        final severity =
            '${_severityColors[issue.severity](_severityHumanReadable[issue.severity]?.padRight(8))}';
        final position =
            '${issue.sourceSpan.start.line}:${issue.sourceSpan.start.column}';
        final rule = [
          issue.ruleId,
          if (issue.ruleDocumentationUri != null) issue.ruleDocumentationUri
        ].join(' ');
        lines.add('$severity${[issue.message, position, rule].join(' : ')}');
      }

      if (lines.isNotEmpty) {
        reportStrings.add('${analysisRecord.relativePath}:');
        reportStrings.addAll(lines);
        reportStrings.add('');
      }
    }

    return reportStrings;
  }

  bool _isNeedToReport(FunctionReportMetric metric) =>
      metric.violationLevel != ViolationLevel.none;

  String _report(FunctionReportMetric<num> metric, String humanReadableName) =>
      '$humanReadableName: ${_colorPens[metric.violationLevel]('${metric.value.toInt()}')}';
}
