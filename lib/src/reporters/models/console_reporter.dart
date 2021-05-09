import 'dart:io';

import 'package:meta/meta.dart';

import 'reporter.dart';

/// Plain terminal reporter
abstract class ConsoleReporter extends Reporter {
  @protected
  final IOSink output;

  const ConsoleReporter(this.output);
}
