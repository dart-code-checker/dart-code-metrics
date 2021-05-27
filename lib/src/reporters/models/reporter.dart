import 'file_report.dart';

/// Abstract reporter interface.
abstract class Reporter<T extends FileReport> {
  Future<void> report(Iterable<T> records);

  const Reporter();
}
