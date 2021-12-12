import 'package:dart_code_metrics/src/utils/path_utils.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  group('uriToPath returns', () {
    test('null for passed null', () {
      expect(uriToPath(null), isNull);
    });

    test(
      'normalize path for passed uri',
      () {
        expect(
          uriToPath(Uri.file('/home/develop/source.txt')),
          equals('/home/develop/source.txt'),
        );
      },
      testOn: 'posix',
    );

    test(
      'normalize path for passed uri',
      () {
        expect(
          uriToPath(Uri.file(r'C:\develop\source.txt')),
          equals(r'C:\develop\source.txt'),
        );
      },
      testOn: 'windows',
    );

    test('null for passed null', () {
      expect(
        uriToPath(
          Uri.parse('package:dart_code_metrics/src/utils/path_utils.dart'),
        ),
        equals(p.absolute('dart_code_metrics/src/utils/path_utils.dart')),
      );
    });
  });
}
