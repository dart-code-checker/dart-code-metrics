import '../models/file_report.dart';

/// Abstract reporter interface.
abstract class Reporter {
  Future<void> report(Iterable<FileReport> records);

  const Reporter();
}
