import 'package:metrics/src/models/component_record.dart';

// ignore: one_member_abstracts
abstract class Reporter {
  void report(Iterable<ComponentRecord> records);
}
