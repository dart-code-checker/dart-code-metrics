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
