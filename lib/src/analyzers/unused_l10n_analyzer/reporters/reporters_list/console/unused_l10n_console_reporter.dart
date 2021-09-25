import 'dart:io';

import 'package:ansicolor/ansicolor.dart';

import '../../../../../reporters/models/console_reporter.dart';
import '../../../models/unused_l10n_file_report.dart';

class UnusedL10nConsoleReporter extends ConsoleReporter<UnusedL10nFileReport> {
  UnusedL10nConsoleReporter(IOSink output) : super(output);

  @override
  Future<void> report(Iterable<UnusedL10nFileReport> records) async {
    if (records.isEmpty) {
      output.writeln('✔ no unused localization found!');

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
        final path = analysisRecord.relativePath;

        output
          ..writeln('⚠ unused ${issue.memberName}'.padRight(8))
          ..writeln('at $path:$line:$column'.padRight(11));
      }

      warnings += analysisRecord.issues.length;

      output.writeln('');
    }

    final color = AnsiPen()..yellow();

    output.writeln(
      '✖ total unused localization usages - ${color(warnings)}',
    );
  }
}
