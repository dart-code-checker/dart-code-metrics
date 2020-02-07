import 'package:dart_code_metrics/src/models/component_record.dart';

abstract class Reporter {
  void report(Iterable<ComponentRecord> records);
}
