import 'dart:io';

import 'package:ansicolor/ansicolor.dart';
import 'package:meta/meta.dart';

import 'file_report.dart';
import 'reporter.dart';

/// Plain terminal reporter
abstract class ConsoleReporter<T extends FileReport, S, P>
    extends Reporter<T, S, P> {
  static const String id = 'console';
  static const String verboseId = 'console-verbose';

  final AnsiPen alarmPen = AnsiPen()..rgb(r: 0.88, g: 0.32, b: 0.36);
  final AnsiPen warningPen = AnsiPen()..rgb(r: 0.98, g: 0.68, b: 0.4);
  final AnsiPen okPen = AnsiPen()..rgb(r: 0.08, g: 0.11, b: 0.81);

  @protected
  final IOSink output;

  ConsoleReporter(this.output);
}
