// ignore_for_file: prefer-trailing-comma
import 'package:ansicolor/ansicolor.dart';

import '../../models/file_report.dart';
import '../../models/metric_value.dart';
import '../../models/metric_value_level.dart';
import '../../models/severity.dart';
import '../../utils/metric_utils.dart';
import '../reporters/reporter.dart';
import '../reporters/utility_selector.dart';

/// Plain terminal reporter
class ConsoleReporter implements Reporter {
  /// If true will report info about all files even if they're not above warning threshold
  final bool reportAll;

  final _colorPens = {
    MetricValueLevel.alarm: AnsiPen()..red(),
    MetricValueLevel.warning: AnsiPen()..yellow(),
    MetricValueLevel.noted: AnsiPen()..blue(),
    MetricValueLevel.none: AnsiPen()..white(),
  };

  static const _humanReadableLabel = {
    MetricValueLevel.alarm: 'ALARM',
    MetricValueLevel.warning: 'WARNING',
    MetricValueLevel.noted: 'NOTED',
    MetricValueLevel.none: '',
  };

  final _severityColors = {
    Severity.error: AnsiPen()..red(),
    Severity.warning: AnsiPen()..yellow(),
    Severity.style: AnsiPen()..blue(),
  };

  final _designIssuesColor = AnsiPen()..yellow();
  static const _designIssues = 'Design';

  ConsoleReporter({this.reportAll = false});

  @override
  Future<Iterable<String>> report(Iterable<FileReport>? records) async {
    if (records?.isEmpty ?? true) {
      return [];
    }

    final reportStrings = <String>[];

    for (final analysisRecord in records!) {
      final lines = <String>[];

      analysisRecord.classes.forEach((source, componentReport) {
        final report = UtilitySelector.componentReport(componentReport);
        final violationLevel = UtilitySelector.componentViolationLevel(report);

        if (reportAll || isReportLevel(violationLevel)) {
          final violations = [
            if (reportAll || _isNeedToReport(report.methodsCount))
              _report(report.methodsCount, 'number of methods'),
          ];
          lines.add(
              '${_colorPens[violationLevel]!(_humanReadableLabel[violationLevel]!.padRight(8))}$source - ${violations.join(', ')}');
        }
      });

      lines.addAll(_reportAboutFunctions(analysisRecord));

      for (final issue in analysisRecord.antiPatternCases) {
        final severity = _designIssuesColor(_designIssues.padRight(8));
        final position =
            '${issue.location.start.line}:${issue.location.start.column}';
        final rule = [
          issue.ruleId,
          issue.documentation,
        ].join(' ');
        lines.add('$severity${[issue.message, position, rule].join(' : ')}');
      }

      for (final issue in analysisRecord.issues) {
        final severity = _severityColors[issue.severity]!(
            '${issue.severity.toString().substring(0, 1).toUpperCase()}${issue.severity.toString().substring(1)}'
                .padRight(8));
        final position =
            '${issue.location.start.line}:${issue.location.start.column}';
        final rule = [
          issue.ruleId,
          issue.documentation,
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

  Iterable<String> _reportAboutFunctions(FileReport record) {
    final lines = <String>[];

    record.functions.forEach((source, functionReport) {
      final report = UtilitySelector.functionReport(functionReport);
      final violationLevel = UtilitySelector.functionViolationLevel(report);

      if (reportAll || isReportLevel(violationLevel)) {
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
            '${_colorPens[violationLevel]!(_humanReadableLabel[violationLevel]!.padRight(8))}$source - ${violations.join(', ')}');
      }
    });

    return lines;
  }

  bool _isNeedToReport(MetricValue metric) =>
      metric.level != MetricValueLevel.none;

  String _report(MetricValue<num> metric, String humanReadableName) =>
      '$humanReadableName: ${_colorPens[metric.level]!('${metric.value.toInt()}')}';
}
