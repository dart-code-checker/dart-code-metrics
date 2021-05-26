import 'dart:io';

import 'package:meta/meta.dart';

import 'reporter.dart';

/// Machine-readable report in JSON format
abstract class JsonReporter extends Reporter {
  static const String id = 'json';

  @protected
  final IOSink output;

  @protected
  final int formatVersion;

  const JsonReporter(this.output, this.formatVersion);
}
