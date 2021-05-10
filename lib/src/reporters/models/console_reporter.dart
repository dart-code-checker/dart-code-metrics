import 'dart:io';

import 'package:meta/meta.dart';

import 'reporter.dart';

/// Plain terminal reporter
abstract class ConsoleReporter extends Reporter {
  static const String id = 'console';
  static const String verboseId = 'console-verbose';

  @protected
  final IOSink output;

  const ConsoleReporter(this.output);
}
