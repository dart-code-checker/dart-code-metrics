import 'dart:io';

import 'package:dart_code_metrics/src/cli/utils/detect_sdk_path.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path/path.dart';
import 'package:test/test.dart';

class FileMock extends Mock implements File {}

void main() {
  group('detectSdkPath', () {
    test('should return `null` for non-Windows platforms', () {
      expect(detectSdkPath('', {}, platformIsWindows: false), null);
    });

    test('should return `null` if running inside VM', () {
      expect(
        detectSdkPath('/some/path/dart.exe', {}, platformIsWindows: true),
        null,
      );
    });

    test('should find sdk path inside environment PATH variable', () {
      IOOverrides.runZoned(
        () {
          expect(
            detectSdkPath(
              'metrics.exe',
              {'PATH': '/some/path;/path/to/dart-sdk/bin;/other/path'},
              platformIsWindows: true,
            ),
            '/path/to/dart-sdk',
          );
        },
        createFile: (path) {
          final file = FileMock();
          when(file.existsSync)
              .thenReturn(path == join('/path/to/dart-sdk/bin', 'dart.exe'));

          return file;
        },
      );
    });
  });
}
