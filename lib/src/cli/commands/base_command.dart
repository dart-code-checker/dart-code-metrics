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
    if (super.argResults == null) {
      throw StateError('Unexpected empty args parse result');
    }

    return super.argResults!;
  }

  @override
  Future<void> run() => _verifyThenRunCommand();

  @protected
  Future<void> runCommand();

  void validateCommand() {
    validateRootFolderExist();
    validateSdkPath();
    validateTargetDirectories();
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

  void addCommonFlags() {
    usesRootFolderOption();
    usesSdkPathOption();
    usesExcludeOption();
    _congratulateFlag();
  }

  String? findSdkPath() =>
      argResults[FlagNames.sdkPath] as String? ??
      detectSdkPath(
        Platform.executable,
        Platform.environment,
        platformIsWindows: Platform.isWindows,
      );

  void _congratulateFlag() {
    argParser
      ..addSeparator('')
      ..addFlag(
        FlagNames.noCongratulate,
        help: "Don't show output even when there are no issues.",
        negatable: false,
        defaultsTo: false,
      );
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
