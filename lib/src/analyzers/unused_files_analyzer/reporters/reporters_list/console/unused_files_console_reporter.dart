import 'dart:io';

import '../../../../../reporters/models/console_reporter.dart';
import '../../../models/unused_files_file_report.dart';
import '../../report_params.dart';

/// Unused files console reporter.
///
/// Use it to create reports in console format.
class UnusedFilesConsoleReporter
    extends ConsoleReporter<UnusedFilesFileReport, void, ReportParams> {
  UnusedFilesConsoleReporter(IOSink output) : super(output);

  @override
  Future<void> report(
    Iterable<UnusedFilesFileReport> records, {
    Iterable<void> summary = const [],
    ReportParams? additionalParams,
  }) async {
    if (records.isEmpty) {
      output.writeln('${okPen('✔')} no unused files found!');

      return;
    }

    final sortedRecords = records.toList()
      ..sort((a, b) => a.relativePath.compareTo(b.relativePath));

    for (final analysisRecord in sortedRecords) {
      output.writeln(
        '${warningPen('⚠')} unused file: ${analysisRecord.relativePath}',
      );
    }

    final removeFilesSuffix = additionalParams?.deleteUnusedFiles ?? false
        ? ', all unused files were successfully deleted'
        : '';

    output
      ..writeln('')
      ..writeln(
        '${alarmPen('✖')} total unused files - ${alarmPen(sortedRecords.length)}$removeFilesSuffix',
      );
  }
}
