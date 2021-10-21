import 'dart:io';

import 'package:ansicolor/ansicolor.dart';

import '../../../../../reporters/models/console_reporter.dart';
import '../../../models/unused_l10n_file_report.dart';

/// Unused localization console reporter.
///
/// Use it to create reports in console format.
class UnusedL10nConsoleReporter
    extends ConsoleReporter<UnusedL10nFileReport, void> {
  final _errorColor = AnsiPen()..red(bold: true);
  final _warningColor = AnsiPen()..yellow(bold: true);
  final _successColor = AnsiPen()..green();

  UnusedL10nConsoleReporter(IOSink output) : super(output);

  @override
  Future<void> report(
    Iterable<UnusedL10nFileReport> records, {
    Iterable<void> summary = const [],
  }) async {
    if (records.isEmpty) {
      output.writeln('${_successColor('✔')} no unused localization found!');

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

        final offset = ''.padRight(3);
        final pathOffset = offset.padRight(5);

        output
          ..writeln('$offset ${_warningColor('⚠')} unused ${issue.memberName}')
          ..writeln('$pathOffset at $path:$line:$column');
      }

      warnings += analysisRecord.issues.length;

      output.writeln('');
    }

    output.writeln(
      '${_errorColor('✖')} total unused localization class fields, getters and methods - ${_errorColor(warnings)}',
    );
  }
}
