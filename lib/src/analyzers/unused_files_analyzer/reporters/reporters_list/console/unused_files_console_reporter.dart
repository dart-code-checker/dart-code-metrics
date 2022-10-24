import '../../../../../reporters/models/console_reporter.dart';
import '../../../models/unused_files_file_report.dart';
import '../../unused_files_report_params.dart';

/// Unused files console reporter.
///
/// Use it to create reports in console format.
class UnusedFilesConsoleReporter
    extends ConsoleReporter<UnusedFilesFileReport, UnusedFilesReportParams> {
  UnusedFilesConsoleReporter(super.output);

  @override
  Future<void> report(
    Iterable<UnusedFilesFileReport> records, {
    UnusedFilesReportParams? additionalParams,
  }) async {
    if (records.isEmpty) {
      if (additionalParams?.congratulate ?? true) {
        output.writeln('${okPen('✔')} no unused files found!');
      }

      return;
    }

    final sortedRecords = records.toList()
      ..sort((a, b) => a.relativePath.compareTo(b.relativePath));

    for (final analysisRecord in sortedRecords) {
      output.writeln(
        '${warningPen('⚠')} unused file: ${analysisRecord.path}',
      );
    }

    final filesCount = alarmPen(sortedRecords.length);

    final outputRecord = (additionalParams?.deleteUnusedFiles ?? false)
        ? '${okPen('✔')} $filesCount files were successfully deleted'
        : '${alarmPen('✖')} total unused files - $filesCount';

    output
      ..writeln('')
      ..writeln(outputRecord);
  }
}
