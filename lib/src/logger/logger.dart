import 'dart:convert';
import 'dart:io';

import 'package:ansicolor/ansicolor.dart';

import 'progress.dart';

final errorPen = AnsiPen()..rgb(r: 0.88, g: 0.32, b: 0.36);
final warningPen = AnsiPen()..rgb(r: 0.98, g: 0.68, b: 0.4);
final okPen = AnsiPen()..rgb(r: 0.23, g: 0.61, b: 0.16);

class Logger {
  final progress = Progress(okPen, warningPen, errorPen);

  bool _isVerbose = false;
  bool get isVerbose => _isVerbose;
  set isVerbose(bool value) {
    _isVerbose = value;

    progress.updateShowProgress = !(_isSilent || _isVerbose);
  }

  bool _isSilent = false;
  bool get isSilent => _isSilent;
  set isSilent(bool value) {
    _isSilent = value;

    progress.updateShowProgress = !(_isSilent || _isVerbose);
  }

  final _queue = <String>[];

  final IOSink _output;

  Logger(this._output);

  void write(String message) => _output.write(message);

  void info(String message) {
    _output.writeln(message);
  }

  void infoVerbose(String message) {
    if (_isVerbose) {
      info(message);
    }
  }

  void error(String message) {
    stderr.writeln(errorPen(message));
  }

  void warn(String message, {String tag = 'WARN'}) {
    stderr.writeln(warningPen('[$tag] $message'));
  }

  void printConfig(Map<String, Object?> config) {
    if (!_isSilent) {
      const encoder = JsonEncoder.withIndent('  ');
      final prettyprint = encoder.convert(config);

      _output
        ..writeln('\n')
        ..writeln(okPen('⚙️ Merged config:'))
        ..writeln(prettyprint)
        ..writeln('\n');
    }
  }

  void updateAvailable(
    String version,
    String newVersion,
    String changelogLink,
  ) {
    if (!_isSilent) {
      _output
        ..writeln()
        ..writeln(
          '🆕 Update available! ${warningPen('$version -> $newVersion')}',
        )
        ..writeln('🆕 Changelog: ${warningPen(changelogLink)}');
    }
  }

  void success(String message) {
    _output.writeln(okPen(message));
  }

  void delayed(String message) => _queue.add(message);

  void flush([void Function(String)? print]) {
    final writeln = print ?? info;

    _queue
      ..forEach(writeln)
      ..clear();
  }

  /// Prompts user with a yes/no question.
  bool confirm(String message, {bool defaultValue = false}) {
    info(message);

    final input = stdin.readLineSync()?.trim();
    final response = input == null || input.isEmpty
        ? defaultValue
        : input.toBoolean() ?? defaultValue;

    stdout.writeln('$message: ${response ? 'Yes' : 'No'}');

    return response;
  }
}

extension on String {
  bool? toBoolean() {
    switch (toLowerCase()) {
      case 'y':
      case 'yea':
      case 'yeah':
      case 'yep':
      case 'yes':
      case 'yup':
        return true;
      case 'n':
      case 'no':
      case 'nope':
        return false;
      default:
        return null;
    }
  }
}
