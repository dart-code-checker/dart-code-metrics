import 'package:dart_code_metrics/src/models/file_record.dart';

/// Abstract reporter interface. Use [MetricsAnalysisRunner] to get analysis info to report
abstract class Reporter {
  Iterable<String> report(Iterable<FileRecord> records);
}
