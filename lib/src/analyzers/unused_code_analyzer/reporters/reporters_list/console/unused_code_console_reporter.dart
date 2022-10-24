import '../../../../../reporters/models/console_reporter.dart';
import '../../../models/unused_code_file_report.dart';
import '../../unused_code_report_params.dart';

/// Unused code console reporter.
///
/// Use it to create reports in console format.
class UnusedCodeConsoleReporter
    extends ConsoleReporter<UnusedCodeFileReport, UnusedCodeReportParams> {
  UnusedCodeConsoleReporter(super.output);

  @override
  Future<void> report(
    Iterable<UnusedCodeFileReport> records, {
    UnusedCodeReportParams? additionalParams,
  }) async {
    if (records.isEmpty) {
      if (additionalParams?.congratulate ?? true) {
        output.writeln('${okPen('✔')} no unused code found!');
      }

      return;
    }

    final sortedRecords = records.toList()
      ..sort((a, b) => a.relativePath.compareTo(b.relativePath));

    var warnings = 0;

    for (final analysisRecord in sortedRecords) {
      output.writeln('${analysisRecord.relativePath}:');

      for (final issue in analysisRecord.issues) {
        final line = issue.location.line;
        final column = issue.location.column;
        final path = analysisRecord.path;

        final offset = ''.padRight(3);
        final pathOffset = offset.padRight(5);

        output
          ..writeln(
            '$offset ${warningPen('⚠')} unused ${issue.declarationType} ${issue.declarationName}',
          )
          ..writeln('$pathOffset at $path:$line:$column');
      }

      warnings += analysisRecord.issues.length;

      output.writeln('');
    }

    output.writeln(
      '${alarmPen('✖')} total unused code (classes, functions, variables, extensions, enums, mixins and type aliases) - ${alarmPen(warnings)}',
    );
  }
}
