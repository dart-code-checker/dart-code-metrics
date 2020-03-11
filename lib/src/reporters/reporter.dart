import 'package:dart_code_metrics/src/models/component_record.dart';

/// Abstract reporter interface. Use [MetricsAnalysisRunner] to get analysis info to report
abstract class Reporter {
  void report(Iterable<ComponentRecord> records);
}
