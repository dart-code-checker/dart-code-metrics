import 'file_report.dart';

/// Abstract reporter interface.
abstract class Reporter<Report extends FileReport, Params> {
  Future<void> report(
    Iterable<Report> records, {
    Params? additionalParams,
  });

  const Reporter();
}
