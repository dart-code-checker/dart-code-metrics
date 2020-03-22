import 'package:ansicolor/ansicolor.dart';
import 'package:dart_code_metrics/src/models/component_record.dart';
import 'package:dart_code_metrics/src/models/config.dart';
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
            if (reportAll ||
                report.cyclomaticComplexityViolationLevel !=
                    ViolationLevel.none)
              'cyclomatic complexity: ${_colorPens[report.cyclomaticComplexityViolationLevel]('${report.cyclomaticComplexity}')}',
            if (reportAll ||
                report.linesOfCodeViolationLevel != ViolationLevel.none)
              'lines of code: ${_colorPens[report.linesOfCodeViolationLevel]('${report.linesOfCode}')}',
            if (reportAll ||
                report.maintainabilityIndexViolationLevel !=
                    ViolationLevel.none)
              'maintainability index: ${_colorPens[report.maintainabilityIndexViolationLevel]('${report.maintainabilityIndex.toInt()}')}',
            if (reportAll ||
                report.argumentsCountViolationLevel != ViolationLevel.none)
              'number of arguments: ${_colorPens[report.argumentsCountViolationLevel]('${report.argumentsCount}')}',
          ];
          lines.add(
              '${_colorPens[violationLevel](_humanReadableLabel[violationLevel]?.padRight(8))}$source - ${violations.join(', ')}');
        }
      });

      if (lines.isNotEmpty) {
        reportStrings.add('${analysisRecord.relativePath}:');
        reportStrings.addAll(lines);
        reportStrings.add('');
      }
    }

    return reportStrings;
  }
}
