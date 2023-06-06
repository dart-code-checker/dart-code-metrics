import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:pub_updater/pub_updater.dart';

import '../logger/logger.dart';
import '../version.dart';
import 'commands/analyze_command.dart';
import 'commands/check_unnecessary_nullable_command.dart';
import 'commands/check_unused_code_command.dart';
import 'commands/check_unused_files_command.dart';
import 'commands/check_unused_l10n_command.dart';
import 'models/flag_names.dart';

/// Represents a cli runner responsible
/// for running a command based on raw cli call data.
class CliRunner extends CommandRunner<void> {
  final Logger _logger;

  final PubUpdater? _pubUpdater;

  CliRunner([IOSink? output, PubUpdater? pubUpdater])
      : _logger = Logger(output ?? stdout),
        _pubUpdater = pubUpdater ?? PubUpdater(),
        super('metrics', 'Analyze and improve your code quality.') {
    [
      AnalyzeCommand(_logger),
      CheckUnusedFilesCommand(_logger),
      CheckUnusedL10nCommand(_logger),
      CheckUnusedCodeCommand(_logger),
      CheckUnnecessaryNullableCommand(_logger),
    ].forEach(addCommand);

    _usesVersionOption();
    _usesDeprecationOption();
  }

  /// Represents the invocation string message.
  @override
  String get invocation => '${super.invocation} <directories>';

  /// Main entry point for running a command.
  @override
  Future<void> run(Iterable<String> args) async {
    try {
      final argsWithDefaultCommand = _addDefaultCommand(args);

      final results = parse(argsWithDefaultCommand);
      final showVersion = results[FlagNames.version] as bool;

      if (showVersion) {
        _logger.info('DCM version: $packageVersion');

        return;
      }

      if (!(results[FlagNames.disableMessage] as bool)) {
        _logger.info(warningPen('''
This package is entering the deprecation process and will be fully discontinued on July 16th.
You can read more in this blog post https://dcm.dev/blog/2023/06/06/announcing-dcm-free-version-sunset/.

We are grateful to you for being a DCM user. If you are a DCM contributor, you can apply for a special license, feel free to reach out to info@dcm.dev.

If you think DCM is valuable and it helps you, please consider to upgrade to the new Individuals or Teams version.

To hide this message pass the 'disable-sunset-warning' option.
'''));
      }

      await super.run(argsWithDefaultCommand);
    } on UsageException catch (e) {
      _logger
        ..info(e.message)
        ..info(e.usage);

      exit(64);
    } on Exception catch (e) {
      _logger.error('Oops; metrics has exited unexpectedly: "$e"');

      exit(1);
    }

    await _checkForUpdates();

    exit(0);
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

  void _usesDeprecationOption() {
    argParser
      ..addSeparator('')
      ..addFlag(
        FlagNames.disableMessage,
        help: 'Hide deprecation message.',
        negatable: false,
      );
  }

  Future<void> _checkForUpdates() async {
    try {
      final latestVersion =
          await _pubUpdater?.getLatestVersion('dart_code_metrics');
      final isUpToDate = packageVersion == latestVersion;
      if (!isUpToDate && latestVersion != null) {
        final changelogLink =
            'https://github.com/dart-code-checker/dart-code-metrics/releases/tag/$latestVersion';
        _logger.updateAvailable(packageVersion, latestVersion, changelogLink);
      }
      // ignore: avoid_catches_without_on_clauses
    } catch (_) {}
  }
}
