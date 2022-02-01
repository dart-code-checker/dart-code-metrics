import 'dart:io';

import 'package:args/command_runner.dart';

import '../version.dart';
import 'commands/analyze_command.dart';
import 'commands/check_unused_code_command.dart';
import 'commands/check_unused_files_command.dart';
import 'commands/check_unused_l10n_command.dart';
import 'models/flag_names.dart';

/// Represents a cli runner responsible
/// for running a command based on raw cli call data.
class CliRunner extends CommandRunner<void> {
  static final _commands = [
    AnalyzeCommand(),
    CheckUnusedFilesCommand(),
    CheckUnusedL10nCommand(),
    CheckUnusedCodeCommand(),
  ];

  late final IOSink _output;

  CliRunner([IOSink? output])
      : super('metrics', 'Analyze and improve your code quality.') {
    _output = output ?? stdout;

    _commands.forEach(addCommand);

    _usesVersionOption();
  }

  /// Represents the invocation string message
  @override
  String get invocation => '${super.invocation} <directories>';

  /// Main entry point for running a command
  @override
  Future<void> run(Iterable<String> args) async {
    try {
      final argsWithDefaultCommand = _addDefaultCommand(args);

      final results = parse(argsWithDefaultCommand);
      final showVersion = results[FlagNames.version] as bool;

      if (showVersion) {
        _output.writeln('Dart Code Metrics version: $packageVersion');

        return;
      }

      await super.run(argsWithDefaultCommand);
    } on UsageException catch (e) {
      _output
        ..writeln(e.message)
        ..writeln(e.usage);

      exit(64);
    } on Exception catch (e) {
      _output.writeln('Oops; metrics has exited unexpectedly: "$e"');

      exit(1);
    }
  }

  Iterable<String> _addDefaultCommand(Iterable<String> args) => args.isEmpty
      ? args
      : !commands.keys.contains(args.first)
          ? ['analyze', ...args]
          : args;

  void _usesVersionOption() {
    argParser
      ..addSeparator('')
      ..addFlag(
        FlagNames.version,
        help: 'Reports the version of this tool.',
        negatable: false,
      );
  }
}
