import 'package:dart_code_metrics/src/cli/cli_runner.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

const _usage = 'Check unused code in *.dart files.\n'
    '\n'
    'Usage: metrics check-unused-code [arguments] <directories>\n'
    '-h, --help                                        Print this usage information.\n'
    '\n'
    '\n'
    '-r, --reporter=<console>                          The format of the output of the analysis.\n'
    '                                                  [console (default), json]\n'
    '\n'
    '\n'
    '    --root-folder=<./>                            Root folder.\n'
    '                                                  (defaults to current directory)\n'
    '    --sdk-path=<directory-path>                   Dart SDK directory path. Should be provided only when you run the application as compiled executable(https://dart.dev/tools/dart-compile#exe) and automatic Dart SDK path detection fails.\n'
    '    --exclude=<{/**.g.dart,/**.template.dart}>    File paths in Glob syntax to be exclude.\n'
    '                                                  (defaults to "{/**.g.dart,/**.template.dart}")\n'
    '\n'
    '\n'
    "    --no-congratulate                             Don't show output even when there are no issues.\n"
    '\n'
    '\n'
    '    --[no-]monorepo                               Treats all exported code as unused by default.\n'
    '\n'
    '\n'
    '    --[no-]fatal-unused                           Treat find unused file as fatal.\n'
    '\n'
    'Run "metrics help" to see global options.';

void main() {
  group('CheckUnusedCodeCommand', () {
    final runner = CliRunner();
    final command = runner.commands['check-unused-code'];

    test('should have correct name', () {
      expect(command?.name, equals('check-unused-code'));
    });

    test('should have correct description', () {
      expect(
        command?.description,
        equals('Check unused code in *.dart files.'),
      );
    });

    test('should have correct invocation', () {
      expect(
        command?.invocation,
        equals('metrics check-unused-code [arguments] <directories>'),
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
