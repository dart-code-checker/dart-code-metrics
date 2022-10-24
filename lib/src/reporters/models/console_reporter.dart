import 'dart:io';

import 'package:ansicolor/ansicolor.dart';
import 'package:meta/meta.dart';

import 'file_report.dart';
import 'reporter.dart';

/// Plain terminal reporter.
abstract class ConsoleReporter<T extends FileReport, P> extends Reporter<T, P> {
  static const String id = 'console';
  static const String verboseId = 'console-verbose';

  final alarmPen = AnsiPen()..rgb(r: 0.88, g: 0.32, b: 0.36);
  final warningPen = AnsiPen()..rgb(r: 0.98, g: 0.68, b: 0.4);
  final okPen = AnsiPen()..rgb(r: 0.23, g: 0.61, b: 0.16);

  @protected
  final IOSink output;

  ConsoleReporter(this.output);
}
