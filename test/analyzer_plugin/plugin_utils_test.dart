@TestOn('vm')
import 'package:dart_code_metrics/src/analyzer_plugin/plugin_utils.dart';
import 'package:test/test.dart';

void main() {
  group('prepareExcludes returns array of Glob with absolute path in', () {
    const patterns = ['.dart_tool/**', 'packages/**', 'src/exclude_me.dart'];
    test('UNIX', () {
      final exludes = prepareExcludes(patterns, '/home/user/project');

      expect(
        exludes.map((exclude) => exclude.pattern),
        equals([
          '/home/user/project/.dart_tool/**',
          '/home/user/project/packages/**',
          '/home/user/project/src/exclude_me.dart',
        ]),
      );
    });

    test('Windows', () {
      final exludes = prepareExcludes(patterns, r'c:\Users\dmitry\Development');

      expect(
        exludes.map((exclude) => exclude.pattern),
        equals([
          'c:/Users/dmitry/Development/.dart_tool/**',
          'c:/Users/dmitry/Development/packages/**',
          'c:/Users/dmitry/Development/src/exclude_me.dart',
        ]),
      );
    });
  });
}
