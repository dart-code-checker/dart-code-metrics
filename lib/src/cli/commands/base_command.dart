// ignore_for_file: public_member_api_docs

import 'dart:io';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart';

import '../exceptions/arguments_validation_exceptions.dart';
import '../models/flag_names.dart';

abstract class BaseCommand extends Command<void> {
  @override
  ArgResults get argResults {
    if (super.argResults == null) {
      throw StateError('Unexpected empty args parse result');
    }

    return super.argResults!;
  }

  @override
  CommandRunner get runner => super.runner as CommandRunner;

  @override
  Future<void> run() => _verifyThenRunCommand();

  @protected
  void validateCommand();

  @protected
  Future<void> runCommand();

  void usesRootFolderOption() {
    argParser
      ..addSeparator('')
      ..addOption(
        FlagNames.rootFolder,
        help: 'Root folder.',
        valueHelp: './',
        defaultsTo: Directory.current.path,
      );
  }

  void usesSdkPathOption() {
    argParser.addOption(
      FlagNames.sdkPath,
      help:
          'Dart SDK directory path. Should be provided only when you run the application as compiled Windows executable and automatic Dart SDK path detection fails.',
      valueHelp: 'directory-path',
    );
  }

  void usesExcludeOption() {
    argParser.addOption(
      FlagNames.exclude,
      help: 'File paths in Glob syntax to be exclude.',
      valueHelp: '{/**.g.dart,/**.template.dart}',
      defaultsTo: '{/**.g.dart,/**.template.dart}',
    );
  }

  void validateRootFolderExist() {
    final rootFolderPath = argResults[FlagNames.rootFolder] as String;
    if (!Directory(rootFolderPath).existsSync()) {
      final _exceptionMessage =
          'Root folder $rootFolderPath does not exist or not a directory.';

      throw InvalidArgumentException(_exceptionMessage);
    }
  }

  void validateSdkPath() {
    final sdkPath = argResults[FlagNames.sdkPath] as String?;
    if (sdkPath != null && !Directory(sdkPath).existsSync()) {
      final _exceptionMessage =
          'Dart SDK path $sdkPath does not exist or not a directory.';

      throw InvalidArgumentException(_exceptionMessage);
    }
  }

  void validateTargetDirectories() {
    if (argResults.rest.isEmpty) {
      const _exceptionMessage =
          'Invalid number of directories. At least one must be specified.';

      throw const InvalidArgumentException(_exceptionMessage);
    }

    final rootFolderPath = argResults[FlagNames.rootFolder] as String;

    for (final relativePath in argResults.rest) {
      final absolutePath = join(rootFolderPath, relativePath);
      if (!Directory(absolutePath).existsSync()) {
        final _exceptionMessage =
            "$absolutePath doesn't exist or isn't a directory.";

        throw InvalidArgumentException(_exceptionMessage);
      }
    }
  }

  String? findSdkPath() {
    var sdkPath = argResults[FlagNames.sdkPath] as String?;

    // When running as compiled Windows executable (built with `dart compile exe`) we must
    // pass Dart SDK path when we create analysis context. So we try to detect Dart SDK path
    // from system %PATH% environment variable.
    //
    // See
    // https://github.com/dart-code-checker/dart-code-metrics/issues/385
    // https://github.com/dart-code-checker/dart-code-metrics/pull/430
    const dartExeFileName = 'dart.exe';

    if (sdkPath == null &&
        Platform.isWindows &&
        !Platform.executable.toLowerCase().endsWith(dartExeFileName)) {
      final paths = Platform.environment['PATH']?.split(';') ?? [];
      final dartExePath = paths.firstWhere(
        (pathEntry) => File(join(pathEntry, dartExeFileName)).existsSync(),
        orElse: () => '',
      );
      if (dartExePath.isNotEmpty) {
        // dart.exe usually is located in %SDK_PATH%\bin directory so let's use parent directory name.
        sdkPath = dirname(dartExePath);
      }
    }

    return sdkPath;
  }

  Future<void> _verifyThenRunCommand() async {
    try {
      validateCommand();
    } on InvalidArgumentException catch (e) {
      usageException(e.message);
    }

    // TODO(incendial): check deprecated here

    return runCommand();
  }
}
