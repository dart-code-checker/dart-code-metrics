@TestOn('vm')
import 'package:dart_code_metrics/src/cli/cli_runner.dart';
import 'package:dart_code_metrics/src/cli/commands/analyze.dart';
import 'package:test/test.dart';

const _usage = 'Collect code metrics, rules and anti-patterns violations.\n'
    '\n'
    'Usage: metrics analyze [arguments] <directories>\n'
    '-h, --help                                        Print this usage information.\n'
    '\n'
    '\n'
    '-r, --reporter=<console>                          The format of the output of the analysis.\n'
    '                                                  [console (default), console-verbose, codeclimate, github, gitlab, html, json]\n'
    '-o, --output-directory=<OUTPUT>                   Write HTML output to OUTPUT.\n'
    '                                                  (defaults to "metrics")\n'
    '\n'
    '\n'
    '    --cyclomatic-complexity=<20>                  Cyclomatic Complexity threshold.\n'
    '    --lines-of-code=<100>                         Lines of Code threshold.\n'
    '    --maximum-nesting-level=<5>                   Maximum Nesting Level threshold.\n'
    '    --number-of-methods=<10>                      Number of Methods threshold.\n'
    '    --number-of-parameters=<4>                    Number of Parameters threshold.\n'
    '    --source-lines-of-code=<50>                   Source lines of Code threshold.\n'
    '    --weight-of-class=<0.33>                      Weight Of a Class threshold.\n'
    '\n'
    '\n'
    '    --root-folder=<./>                            Root folder.\n'
    '                                                  (defaults to current directory)\n'
    '    --exclude=<{/**.g.dart,/**.template.dart}>    File paths in Glob syntax to be exclude.\n'
    '                                                  (defaults to "{/**.g.dart,/**.template.dart}")\n'
    '\n'
    '\n'
    '    --set-exit-on-violation-level=<warning>       Set exit code 2 if code violations same or higher level than selected are detected.\n'
    '                                                  [noted, warning, alarm]\n'
    '\n'
    'Run "metrics help" to see global options.';

void main() {
  group('AnalyzeCommand', () {
    final runner = CliRunner();
    final command = runner.commands['analyze'] as AnalyzeCommand;

    test('should have correct name', () {
      expect(command.name, 'analyze');
    });

    test('should have correct description', () {
      expect(
        command.description,
        'Collect code metrics, rules and anti-patterns violations.',
      );
    });

    test('should have correct invocation', () {
      expect(
        command.invocation,
        'metrics analyze [arguments] <directories>',
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
