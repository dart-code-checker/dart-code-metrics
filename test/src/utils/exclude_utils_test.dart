import 'package:dart_code_metrics/src/utils/exclude_utils.dart';
import 'package:glob/glob.dart';
import 'package:test/test.dart';

void main() {
  group('isExcluded checks passed path to exclude', () {
    test(
      'UNIX style paths',
      () {
        final excludes = [
          '/home/user/project/.dart_tool/**',
          '/home/user/project/packages/**',
          '/home/user/project/src/exclude_me.dart',
        ].map((item) => Glob(item));

        expect(
          isExcluded('/home/user/project/src/exclude_me.dart', excludes),
          isTrue,
        );
      },
      testOn: 'posix',
    );

    test('Windows style paths', () {
      final excludes = [
        'c:/Users/dmitry/Development/.dart_tool/**',
        'c:/Users/dmitry/Development/packages/**',
        'c:/Users/dmitry/Development/src/exclude_me.dart',
      ].map((item) => Glob(item));

      expect(
        isExcluded(
          r'c:\Users\dmitry\Development/src/exclude_me.dart',
          excludes,
        ),
        isTrue,
      );
    });
  });

  group('prepareExcludes returns array of Glob with absolute path in', () {
    const patterns = ['.dart_tool/**', 'packages/**', 'src/exclude_me.dart'];
    test('UNIX', () {
      final excludes = prepareExcludes(patterns, '/home/user/project');

      expect(
        excludes.map((exclude) => exclude.pattern),
        equals([
          '/home/user/project/.dart_tool/**',
          '/home/user/project/packages/**',
          '/home/user/project/src/exclude_me.dart',
        ]),
      );
    });

    test('Windows', () {
      final excludes =
          prepareExcludes(patterns, r'c:\Users\dmitry\Development');

      expect(
        excludes.map((exclude) => exclude.pattern),
        equals([
          'c:/Users/dmitry/Development/.dart_tool/**',
          'c:/Users/dmitry/Development/packages/**',
          'c:/Users/dmitry/Development/src/exclude_me.dart',
        ]),
      );
    });
  });
}
