import 'dart:io';

import 'package:meta/meta.dart';

import 'file_report.dart';
import 'reporter.dart';

/// Plain terminal reporter
abstract class ConsoleReporter<T extends FileReport> extends Reporter<T> {
  static const String id = 'console';
  static const String verboseId = 'console-verbose';

  @protected
  final IOSink output;

  const ConsoleReporter(this.output);
}
