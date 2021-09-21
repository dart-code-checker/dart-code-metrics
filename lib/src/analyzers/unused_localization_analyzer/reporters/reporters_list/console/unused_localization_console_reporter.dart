import 'dart:io';

import 'package:ansicolor/ansicolor.dart';

import '../../../../../reporters/models/console_reporter.dart';
import '../../../models/unused_localization_file_report.dart';

class UnusedLocalizationConsoleReporter
    extends ConsoleReporter<UnusedLocalizationFileReport> {
  UnusedLocalizationConsoleReporter(IOSink output) : super(output);

  @override
  Future<void> report(Iterable<UnusedLocalizationFileReport> records) async {
    if (records.isEmpty) {
      output.writeln('✔ no unused localization found!');

      return;
    }

    final sortedRecords = records.toList()
      ..sort((a, b) => a.relativePath.compareTo(b.relativePath));

    var warnings = 0;

    for (final analysisRecord in sortedRecords) {
      output.writeln(
          'class ${analysisRecord.className}: ${analysisRecord.relativePath}');

      for (final sourceSpan in analysisRecord.unusedMembersLocation) {
        output.writeln(
            '⚠ unused ${sourceSpan.text}: ${analysisRecord.relativePath}:${sourceSpan.start.line}:${sourceSpan.start.column}'
                .padRight(8));
      }

      warnings += analysisRecord.unusedMembersLocation.length;

      output.writeln('');
    }

    final color = AnsiPen()..yellow();

    output.writeln(
      '✖ total unused localization usages - ${color(warnings)}',
    );
  }
}
