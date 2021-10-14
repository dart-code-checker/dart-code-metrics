import 'file_report.dart';

/// Abstract reporter interface.
abstract class Reporter<T extends FileReport, S> {
  Future<void> report(Iterable<T> records, {Iterable<S> summary = const []});

  const Reporter();
}
