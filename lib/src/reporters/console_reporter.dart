import 'package:ansicolor/ansicolor.dart';
import 'package:meta/meta.dart';

import '../config/config.dart';
import '../models/code_issue_severity.dart';
import '../models/file_record.dart';
import '../models/report_metric.dart';
import '../models/violation_level.dart';
import '../reporters/reporter.dart';
import '../reporters/utility_selector.dart';

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

  static const _humanReadableLabel = {
    ViolationLevel.alarm: 'ALARM',
    ViolationLevel.warning: 'WARNING',
    ViolationLevel.noted: 'NOTED',
    ViolationLevel.none: '',
  };

  final _severityColors = {
    CodeIssueSeverity.style: AnsiPen()..blue(),
    CodeIssueSeverity.warning: AnsiPen()..yellow(),
    CodeIssueSeverity.error: AnsiPen()..red(),
  };

  static const _severityHumanReadable = {
    CodeIssueSeverity.style: 'Style',
    CodeIssueSeverity.warning: 'Warning',
    CodeIssueSeverity.error: 'Error',
  };

  final _designIssuesColor = AnsiPen()..yellow();
  static const _designIssues = 'Design';

  ConsoleReporter({@required this.reportConfig, this.reportAll = false});

  @override
  Iterable<String> report(Iterable<FileRecord> records) {
    if (records?.isEmpty ?? true) {
      return [];
    }

    final reportStrings = <String>[];

    for (final analysisRecord in records) {
      final lines = <String>[];

      analysisRecord.components.forEach((source, componentReport) {
        final report =
            UtilitySelector.componentReport(componentReport, reportConfig);
        final violationLevel = UtilitySelector.componentViolationLevel(report);

        if (reportAll || UtilitySelector.isIssueLevel(violationLevel)) {
          final violations = [
            if (reportAll || _isNeedToReport(report.methodsCount))
              _report(report.methodsCount, 'number of methods'),
          ];
          lines.add(
              '${_colorPens[violationLevel](_humanReadableLabel[violationLevel]?.padRight(8))}$source - ${violations.join(', ')}');
        }
      });

      lines.addAll(_reportAboutFunctions(analysisRecord));

      for (final issue in analysisRecord.designIssues) {
        final severity = _designIssuesColor(_designIssues.padRight(8));
        final position =
            '${issue.sourceSpan.start.line}:${issue.sourceSpan.start.column}';
        final rule = [
          issue.patternId,
          if (issue.patternDocumentation != null) issue.patternDocumentation,
        ].join(' ');
        lines.add('$severity${[issue.message, position, rule].join(' : ')}');
      }

      for (final issue in analysisRecord.issues) {
        final severity = _severityColors[issue.severity](
            _severityHumanReadable[issue.severity]?.padRight(8));
        final position =
            '${issue.sourceSpan.start.line}:${issue.sourceSpan.start.column}';
        final rule = [
          issue.ruleId,
          if (issue.ruleDocumentation != null) issue.ruleDocumentation,
        ].join(' ');
        lines.add('$severity${[issue.message, position, rule].join(' : ')}');
      }

      if (lines.isNotEmpty) {
        reportStrings
          ..add('${analysisRecord.relativePath}:')
          ..addAll(lines)
          ..add('');
      }
    }

    return reportStrings;
  }

  Iterable<String> _reportAboutFunctions(FileRecord record) {
    final lines = <String>[];

    record.functions.forEach((source, functionReport) {
      final report =
          UtilitySelector.functionReport(functionReport, reportConfig);
      final violationLevel = UtilitySelector.functionViolationLevel(report);

      if (reportAll || UtilitySelector.isIssueLevel(violationLevel)) {
        final violations = [
          if (reportAll || _isNeedToReport(report.cyclomaticComplexity))
            _report(report.cyclomaticComplexity, 'cyclomatic complexity'),
          if (reportAll || _isNeedToReport(report.linesOfExecutableCode))
            _report(report.linesOfExecutableCode, 'lines of executable code'),
          if (reportAll || _isNeedToReport(report.maintainabilityIndex))
            _report(report.maintainabilityIndex, 'maintainability index'),
          if (reportAll || _isNeedToReport(report.argumentsCount))
            _report(report.argumentsCount, 'number of arguments'),
          if (reportAll || _isNeedToReport(report.maximumNestingLevel))
            _report(report.maximumNestingLevel, 'nesting level'),
        ];
        lines.add(
            '${_colorPens[violationLevel](_humanReadableLabel[violationLevel]?.padRight(8))}$source - ${violations.join(', ')}');
      }
    });

    return lines;
  }

  bool _isNeedToReport(ReportMetric metric) =>
      metric.violationLevel != ViolationLevel.none;

  String _report(ReportMetric<num> metric, String humanReadableName) =>
      '$humanReadableName: ${_colorPens[metric.violationLevel]('${metric.value.toInt()}')}';
}
