import '../../../../../reporters/models/console_reporter.dart';
import '../../../models/unused_l10n_file_report.dart';
import '../../unused_l10n_report_params.dart';

/// Unused localization console reporter.
///
/// Use it to create reports in console format.
class UnusedL10nConsoleReporter
    extends ConsoleReporter<UnusedL10nFileReport, UnusedL10NReportParams> {
  UnusedL10nConsoleReporter(super.output);

  @override
  Future<void> report(
    Iterable<UnusedL10nFileReport> records, {
    UnusedL10NReportParams? additionalParams,
  }) async {
    if (records.isEmpty) {
      if (additionalParams?.congratulate ?? true) {
        output.writeln('${okPen('✔')} no unused localization found!');
      }

      return;
    }

    final sortedRecords = records.toList()
      ..sort((a, b) => a.relativePath.compareTo(b.relativePath));

    var warnings = 0;

    for (final analysisRecord in sortedRecords) {
      output.writeln('class ${analysisRecord.className}');

      for (final issue in analysisRecord.issues) {
        final line = issue.location.line;
        final column = issue.location.column;
        final path = analysisRecord.path;

        final offset = ''.padRight(3);
        final pathOffset = offset.padRight(5);

        output
          ..writeln('$offset ${warningPen('⚠')} unused ${issue.memberName}')
          ..writeln('$pathOffset at $path:$line:$column');
      }

      warnings += analysisRecord.issues.length;

      output.writeln('');
    }

    output.writeln(
      '${alarmPen('✖')} total unused localization class fields, getters and methods - ${alarmPen(warnings)}',
    );
  }
}
