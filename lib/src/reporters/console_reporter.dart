import 'package:ansicolor/ansicolor.dart';
import 'package:meta/meta.dart';
import 'package:metrics/src/models/component_record.dart';
import 'package:metrics/src/models/config.dart';
import 'package:metrics/src/models/violation_level.dart';
import 'package:metrics/src/reporters/reporter.dart';
import 'package:metrics/src/reporters/utility_selector.dart';

class ConsoleReporter implements Reporter {
  final Config reportConfig;
  final bool reportAll;

  final _redPen = AnsiPen()..red();
  final _yellowPen = AnsiPen()..yellow();
  final _bluePen = AnsiPen()..blue();

  ConsoleReporter({@required this.reportConfig, this.reportAll = false});

  @override
  void report(Iterable<ComponentRecord> records) {
    if (records?.isEmpty ?? true) {
      return;
    }

    for (final analysisRecord in records) {
      final lines = <String>[];

      analysisRecord.records.forEach((source, functionReport) {
        final report = UtilitySelector.functionReport(functionReport, reportConfig);

        switch (report.cyclomaticComplexityViolationLevel) {
          case ViolationLevel.alarm:
            lines.add('${_redPen('ALARM')}   $source - complexity: ${_redPen('${report.cyclomaticComplexity}')}');
            break;
          case ViolationLevel.warning:
            lines.add('${_yellowPen('WARNING')} $source - complexity: ${_yellowPen('${report.cyclomaticComplexity}')}');
            break;
          case ViolationLevel.noted:
            lines.add('${_bluePen('NOTED')}   $source - complexity: ${_yellowPen('${report.cyclomaticComplexity}')}');
            break;
          case ViolationLevel.none:
            if (reportAll) {
              lines.add('        $source - complexity: ${report.cyclomaticComplexity}');
            }
            break;
        }
      });

      if (lines.isNotEmpty || reportAll) {
        final report = UtilitySelector.analysisReport(analysisRecord, reportConfig);

        var consoleRecord = analysisRecord.relativePath;
        consoleRecord += ' - complexity: ${report.totalCyclomaticComplexity}';
        if (report.totalCyclomaticComplexityViolations > 0) {
          consoleRecord += '  complexity violations: ${_yellowPen('${report.totalCyclomaticComplexityViolations}')}';
        }
        consoleRecord += '  lines of code: ${report.totalLinesOfCode}';

        print(consoleRecord);
        lines.forEach(print);
        print('');
      }
    }

    final report = UtilitySelector.analysisReportForRecords(records, reportConfig);

    var packageTotalRecord = 'Total complexity: ${report.totalCyclomaticComplexity}';
    if (report.totalCyclomaticComplexityViolations > 0) {
      packageTotalRecord += '  complexity violations: ${_yellowPen('${report.totalCyclomaticComplexityViolations}')}';
    }
    packageTotalRecord += '  lines of code: ${report.totalLinesOfCode}';

    print(packageTotalRecord);
  }
}
