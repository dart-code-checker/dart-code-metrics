import 'dart:io';

import 'package:meta/meta.dart';

import 'file_report.dart';
import 'reporter.dart';

/// Machine-readable report in JSON format.
abstract class JsonReporter<T extends FileReport, P> extends Reporter<T, P> {
  static const String id = 'json';

  @protected
  final IOSink output;

  @protected
  final int formatVersion;

  const JsonReporter(this.output, this.formatVersion);

  /// Returns a string representation of a timestamp.
  String getTimestamp() {
    final nowTime = DateTime.now();

    return DateTime(
      nowTime.year,
      nowTime.month,
      nowTime.day,
      nowTime.hour,
      nowTime.minute,
      nowTime.second,
    ).toString();
  }
}
