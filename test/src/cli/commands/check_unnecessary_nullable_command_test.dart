import 'package:dart_code_metrics/src/cli/cli_runner.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

const _usage =
    'Check unnecessary nullable parameters in functions, methods, constructors.\n'
    '\n'
    'Usage: metrics check-unnecessary-nullable [arguments] <directories>\n'
    '-h, --help                                       Print this usage information.\n'
    '\n'
    '\n'
    '-r, --reporter=<console>                         The format of the output of the analysis.\n'
    '                                                 [console (default), json]\n'
    '\n'
    '\n'
    '-c, --print-config                               Print resolved config.\n'
    '\n'
    '\n'
    '    --root-folder=<./>                           Root folder.\n'
    '                                                 (defaults to current directory)\n'
    '    --sdk-path=<directory-path>                  Dart SDK directory path. Should be provided only when you run the application as compiled executable(https://dart.dev/tools/dart-compile#exe) and automatic Dart SDK path detection fails.\n'
    '    --exclude=<{/**.g.dart,/**.freezed.dart}>    File paths in Glob syntax to be exclude.\n'
    '                                                 (defaults to "{/**.g.dart,/**.freezed.dart}")\n'
    '\n'
    '\n'
    "    --no-congratulate                            Don't show output even when there are no issues.\n"
    '\n'
    '\n'
    '    --[no-]verbose                               Show verbose logs.\n'
    '\n'
    '\n'
    '    --[no-]monorepo                              Treat all exported code with parameters as non-nullable by default.\n'
    '\n'
    '\n'
    '    --[no-]fatal-found                           Treat found unnecessary nullable parameters as fatal.\n'
    '                                                 (defaults to on)\n'
    '\n'
    'Run "metrics help" to see global options.';

void main() {
  group('CheckUnnecessaryNullableCommand', () {
    final runner = CliRunner();
    final command = runner.commands['check-unnecessary-nullable'];

    test('should have correct name', () {
      expect(command?.name, equals('check-unnecessary-nullable'));
    });

    test('should have correct description', () {
      expect(
        command?.description,
        equals(
          'Check unnecessary nullable parameters in functions, methods, constructors.',
        ),
      );
    });

    test('should have correct invocation', () {
      expect(
        command?.invocation,
        equals('metrics check-unnecessary-nullable [arguments] <directories>'),
      );
    });

    test('should have correct usage', () {
      expect(
        command?.usage.replaceAll('"${p.current}"', 'current directory'),
        equals(_usage),
      );
    });
  });
}
