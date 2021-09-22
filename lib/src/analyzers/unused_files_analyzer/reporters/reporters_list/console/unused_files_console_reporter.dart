import 'dart:io';

import 'package:ansicolor/ansicolor.dart';

import '../../../../../reporters/models/console_reporter.dart';
import '../../../models/unused_files_file_report.dart';

class UnusedFilesConsoleReporter
    extends ConsoleReporter<Iterable<UnusedFilesFileReport>> {
  UnusedFilesConsoleReporter(IOSink output) : super(output);

  @override
  Future<void> report(Iterable<UnusedFilesFileReport> report) async {
    if (report.isEmpty) {
      output.writeln('No unused files found!');

      return;
    }

    final sortedRecords = report.toList()
      ..sort((a, b) => a.relativePath.compareTo(b.relativePath));

    for (final analysisRecord in sortedRecords) {
      output.writeln('Unused file: ${analysisRecord.relativePath}');
    }

    final color = AnsiPen()..yellow();

    output
      ..writeln('')
      ..writeln('Total unused files - ${color(sortedRecords.length)}');
  }
}
