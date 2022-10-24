import '../../../../../reporters/models/console_reporter.dart';
import '../../../models/unnecessary_nullable_file_report.dart';
import '../../unnecessary_nullable_report_params.dart';

/// Unnecessary nullable console reporter.
///
/// Use it to create reports in console format.
class UnnecessaryNullableConsoleReporter extends ConsoleReporter<
    UnnecessaryNullableFileReport, UnnecessaryNullableReportParams> {
  UnnecessaryNullableConsoleReporter(super.output);

  @override
  Future<void> report(
    Iterable<UnnecessaryNullableFileReport> records, {
    UnnecessaryNullableReportParams? additionalParams,
  }) async {
    if (records.isEmpty) {
      if (additionalParams?.congratulate ?? true) {
        output
            .writeln('${okPen('✔')} no unnecessary nullable parameters found!');
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
            '$offset ${warningPen('⚠')} ${issue.declarationType} ${issue.declarationName} has unnecessary nullable parameters',
          )
          ..writeln('$pathOffset ${issue.parameters}')
          ..writeln('$pathOffset at $path:$line:$column');
      }

      warnings += analysisRecord.issues.length;

      output.writeln('');
    }

    output.writeln(
      '${alarmPen('✖')} total declarations (functions, methods and constructors) with unnecessary nullable parameters - ${alarmPen(warnings)}',
    );
  }
}
