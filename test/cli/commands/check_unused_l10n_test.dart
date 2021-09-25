@TestOn('vm')
import 'package:dart_code_metrics/src/cli/cli_runner.dart';
import 'package:dart_code_metrics/src/cli/commands/check_unused_l10n.dart';
import 'package:test/test.dart';

const _usage = 'Check unused localization in *.dart files.\n'
    '\n'
    'Usage: metrics check-unused-l10n [arguments] <directories>\n'
    '-h, --help                                        Print this usage information.\n'
    '\n'
    '\n'
    '-p, --class-pattern=<I18n\$>                       The pattern to detect classes providing localization\n'
    '                                                  (defaults to "I18n\$")\n'
    '\n'
    '\n'
    '-r, --reporter=<console>                          The format of the output of the analysis.\n'
    '                                                  [console (default), json]\n'
    '\n'
    '\n'
    '    --root-folder=<./>                            Root folder.\n'
    '                                                  (defaults to current directory)\n'
    '    --exclude=<{/**.g.dart,/**.template.dart}>    File paths in Glob syntax to be exclude.\n'
    '                                                  (defaults to "{/**.g.dart,/**.template.dart}")\n'
    '\n'
    'Run "metrics help" to see global options.';

void main() {
  group('CheckUnusedL10nCommand', () {
    final runner = CliRunner();
    final command =
        runner.commands['check-unused-l10n'] as CheckUnusedL10nCommand;

    test('should have correct name', () {
      expect(command.name, 'check-unused-l10n');
    });

    test('should have correct description', () {
      expect(
        command.description,
        'Check unused localization in *.dart files.',
      );
    });

    test('should have correct invocation', () {
      expect(
        command.invocation,
        'metrics check-unused-l10n [arguments] <directories>',
      );
    });

    test('should have correct usage', () {
      expect(
        command.usage.replaceAll(
          RegExp('defaults to "(.*?)dart-code-metrics"'),
          'defaults to current directory',
        ),
        _usage,
      );
    });
  });
}
