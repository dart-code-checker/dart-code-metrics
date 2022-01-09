import 'file_report.dart';

/// Abstract reporter interface.
abstract class Reporter<T extends FileReport, S, Params> {
  Future<void> report(
    Iterable<T> records, {
    Iterable<S> summary = const [],
    Params? additionalParams,
  });

  const Reporter();
}
