// ignore_for_file: public_member_api_docs

import 'dart:io';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart';

import '../exceptions/invalid_argument_exception.dart';
import '../models/flag_names.dart';
import '../utils/detect_sdk_path.dart';

abstract class BaseCommand extends Command<void> {
  @override
  ArgResults get argResults {
    final results = super.argResults;
    if (results == null) {
      throw StateError('Unexpected empty args parse result');
    }

    return results;
  }

  bool get isNoCongratulate => argResults[FlagNames.noCongratulate] as bool;

  bool get isVerbose => argResults[FlagNames.verbose] as bool;

  @override
  Future<void> run() => _verifyThenRunCommand();

  @protected
  Future<void> runCommand();

  void validateCommand() {
    validateRootFolderExist();
    validateSdkPath();
    validateTargetDirectoriesOrFiles();
  }

  void validateRootFolderExist() {
    final rootFolderPath = argResults[FlagNames.rootFolder] as String;
    if (!Directory(rootFolderPath).existsSync()) {
      final exceptionMessage =
          'Root folder $rootFolderPath does not exist or not a directory.';

      throw InvalidArgumentException(exceptionMessage);
    }
  }

  void validateSdkPath() {
    final sdkPath = argResults[FlagNames.sdkPath] as String?;
    if (sdkPath != null && !Directory(sdkPath).existsSync()) {
      final exceptionMessage =
          'Dart SDK path $sdkPath does not exist or not a directory.';

      throw InvalidArgumentException(exceptionMessage);
    }
  }

  void validateTargetDirectoriesOrFiles() {
    if (argResults.rest.isEmpty) {
      const exceptionMessage =
          'Invalid number of directories or files. At least one must be specified.';

      throw const InvalidArgumentException(exceptionMessage);
    }

    final rootFolderPath = argResults[FlagNames.rootFolder] as String;

    for (final relativePath in argResults.rest) {
      final absolutePath = join(rootFolderPath, relativePath);
      if (!Directory(absolutePath).existsSync() &&
          !File(absolutePath).existsSync()) {
        final exceptionMessage =
            "$absolutePath doesn't exist or isn't a directory or a file.";

        throw InvalidArgumentException(exceptionMessage);
      }
    }
  }

  void addCommonFlags() {
    usesPrintConfig();
    usesRootFolderOption();
    usesSdkPathOption();
    usesExcludeOption();
    usesCongratulateFlag();
    usesVerboseFlag();
  }

  void usesPrintConfig() {
    argParser
      ..addSeparator('')
      ..addFlag(
        FlagNames.printConfig,
        abbr: 'c',
        help: 'Print resolved config.',
        negatable: false,
      );
  }

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
          'Dart SDK directory path. Should be provided only when you run the application as compiled executable(https://dart.dev/tools/dart-compile#exe) and automatic Dart SDK path detection fails.',
      valueHelp: 'directory-path',
    );
  }

  void usesExcludeOption() {
    argParser.addOption(
      FlagNames.exclude,
      help: 'File paths in Glob syntax to be exclude.',
      valueHelp: '{/**.g.dart,/**.freezed.dart}',
      defaultsTo: '{/**.g.dart,/**.freezed.dart}',
    );
  }

  void usesCongratulateFlag() {
    argParser
      ..addSeparator('')
      ..addFlag(
        FlagNames.noCongratulate,
        help: "Don't show output even when there are no issues.",
        negatable: false,
        defaultsTo: false,
      );
  }

  void usesVerboseFlag() {
    argParser
      ..addSeparator('')
      ..addFlag(
        FlagNames.verbose,
        help: 'Show verbose logs.',
        defaultsTo: false,
      );
  }

  String? findSdkPath() =>
      argResults[FlagNames.sdkPath] as String? ??
      detectSdkPath(
        Platform.executable,
        Platform.environment,
        platformIsWindows: Platform.isWindows,
      );

  Future<void> _verifyThenRunCommand() async {
    try {
      validateCommand();
    } on InvalidArgumentException catch (e) {
      usageException(e.message);
    }

    return runCommand();
  }
}
