import 'dart:io';

import 'package:args/args.dart';
import 'package:path/path.dart' as p;

import 'arguments_parser.dart';
import 'arguments_validation_exceptions.dart';

/// Umbrella method to run all checks throws [InvalidArgumentException]
void validateArguments(ArgResults arguments) {
  checkRootFolderExistAndDirectory(arguments);
  checkPathsToAnalyzeNotEmpty(arguments);
  checkPathsExistAndDirectories(arguments);
}

void checkRootFolderExistAndDirectory(ArgResults arguments) {
  final rootFolderPath = arguments[rootFolderName] as String;
  if (!Directory(rootFolderPath).existsSync()) {
    final _exceptionMessage =
        'Root folder $rootFolderPath does not exist or not a directory';

    throw InvalidArgumentException(_exceptionMessage);
  }
}

void checkPathsToAnalyzeNotEmpty(ArgResults arguments) {
  if (arguments.rest.isEmpty) {
    const _exceptionMessage =
        'Invalid number of directories. At least one must be specified';

    throw const InvalidArgumentException(_exceptionMessage);
  }
}

void checkPathsExistAndDirectories(ArgResults arguments) {
  final rootFolderPath = arguments[rootFolderName] as String;

  for (final relativePath in arguments.rest) {
    final absolutePath = p.join(rootFolderPath, relativePath);
    if (!Directory(absolutePath).existsSync()) {
      final _exceptionMessage =
          "$absolutePath doesn't exist or isn't a directory";

      throw InvalidArgumentException(_exceptionMessage);
    }
  }
}
