import 'package:dart_code_metrics/src/cli/cli_runner.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

const _usage = 'Check unused localization in *.dart files.\n'
    '\n'
    'Usage: metrics check-unused-l10n [arguments] <directories>\n'
    '-h, --help                                       Print this usage information.\n'
    '\n'
    '\n'
    '-p, --class-pattern=<I18n\$>                      The pattern to detect classes providing localization\n'
    '                                                 (defaults to "I18n\$")\n'
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
    '    --[no-]fatal-unused                          Treat find unused l10n as fatal.\n'
    '                                                 (defaults to on)\n'
    '\n'
    'Run "metrics help" to see global options.';

void main() {
  group('CheckUnusedL10nCommand', () {
    final runner = CliRunner();
    final command = runner.commands['check-unused-l10n'];

    test('should have correct name', () {
      expect(command?.name, equals('check-unused-l10n'));
    });

    test('should have correct description', () {
      expect(
        command?.description,
        equals('Check unused localization in *.dart files.'),
      );
    });

    test('should have correct invocation', () {
      expect(
        command?.invocation,
        equals('metrics check-unused-l10n [arguments] <directories>'),
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
