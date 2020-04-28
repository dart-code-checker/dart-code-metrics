import 'dart:isolate';

import 'package:dart_code_metrics/analyzer_plugin.dart';

void main(List<String> args, SendPort sendPort) {
  start(args, sendPort);
}
