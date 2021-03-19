import 'dart:io';

import 'package:pub_semver/pub_semver.dart';

Version getAnalyzerVersion() {
  final lockFileContent = File('pubspec.lock').readAsStringSync();

  final packageInfo =
      lockFileContent.substring(lockFileContent.indexOf('analyzer'));
  final packageVersionInfo =
      packageInfo.substring(packageInfo.indexOf('version'));
  var packageVersion =
      packageVersionInfo.substring(packageVersionInfo.indexOf('"') + 1);
  packageVersion = packageVersion.substring(0, packageVersion.indexOf('"'));

  return Version.parse(packageVersion);
}
