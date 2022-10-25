import 'dart:async';
import 'dart:io';

import 'package:ansicolor/ansicolor.dart';

const _progressAnimation = [
  '⠋',
  '⠙',
  '⠹',
  '⠸',
  '⠼',
  '⠴',
  '⠦',
  '⠧',
  '⠇',
  '⠏',
];

class Progress {
  final _stopwatch = Stopwatch();

  final AnsiPen okPen;
  final AnsiPen warningPen;
  final AnsiPen errorPen;

  int _index = 0;

  Timer? _timer;

  String? _message;

  bool _showProgress = true;
  // ignore: avoid_setters_without_getters
  set updateShowProgress(bool value) {
    _showProgress = value;
  }

  Progress(this.okPen, this.warningPen, this.errorPen);

  void start(String message) {
    _message = message;
    _stopwatch
      ..reset()
      ..start();

    _timer = Timer.periodic(const Duration(milliseconds: 80), _onTick);

    _onTick(_timer, false);
  }

  void update(String update) {
    _write(_clearLn);
    _message = update;

    _onTick(_timer);
  }

  void cancel() {
    _timer?.cancel();
    _write(_clearLn);
    _stopwatch.stop();
  }

  void complete([String? update]) {
    _stopwatch.stop();
    _writeLn('$_clearLn${okPen('✔')} ${update ?? _message} $_time\n');
    _timer?.cancel();
  }

  void fail([String? update]) {
    _timer?.cancel();
    _writeLn('$_clearLn${errorPen('✗')} ${update ?? _message} $_time\n');
    _stopwatch.stop();
  }

  void _onTick(Timer? _, [bool withTime = true]) {
    _index++;
    final char = _progressAnimation[_index % _progressAnimation.length];
    _write('$_clearLn$char $_message... ${withTime ? _time : ''}'.trim());
  }

  void _write(Object? object) {
    if (_showProgress) {
      stdout.write(object);
    }
  }

  void _writeLn(Object? object) {
    if (_showProgress) {
      stdout.writeln(object);
    }
  }

  String get _clearLn => '\u001b[2K'
      '\r';

  String get _time {
    final elapsedTime = _stopwatch.elapsed.inMilliseconds;
    final displayInMilliseconds = elapsedTime < 100;
    final time = displayInMilliseconds ? elapsedTime : elapsedTime / 1000;
    final formattedTime =
        displayInMilliseconds ? '${time}ms' : '${time.toStringAsFixed(1)}s';

    return formattedTime;
  }
}
