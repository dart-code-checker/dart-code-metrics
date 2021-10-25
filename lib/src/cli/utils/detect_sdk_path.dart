import 'dart:io';

import 'package:path/path.dart';

String? detectSdkPath(
  String platformExecutable,
  Map<String, String> platformEnvironment, {
  required bool platformIsWindows,
}) {
  String? sdkPath;
  // When running as compiled executable (built with `dart compile exe`) we must
  // pass Dart SDK path when we create analysis context. So we try to detect Dart SDK path
  // from system %PATH% environment variable.
  //
  // See
  // https://github.com/dart-code-checker/dart-code-metrics/issues/385
  // https://github.com/dart-code-checker/dart-code-metrics/pull/430
  const dartExeFileName = 'dart.exe';

  if (platformIsWindows &&
      !platformExecutable.toLowerCase().endsWith(dartExeFileName)) {
    final paths = platformEnvironment['PATH']?.split(';') ?? [];
    final dartExePath = paths.firstWhere(
      (pathEntry) => File(join(pathEntry, dartExeFileName)).existsSync(),
      orElse: () => '',
    );
    if (dartExePath.isNotEmpty) {
      // dart.exe usually is located in %SDK_PATH%\bin directory so let's use parent directory name.
      sdkPath = dirname(dartExePath);
    }
  }

  return sdkPath;
}
