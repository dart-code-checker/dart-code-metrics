// ignore_for_file: public_member_api_docs, prefer-trailing-comma
import 'dart:io';

import 'package:args/args.dart';
import 'package:code_checker/checker.dart';
import 'package:path/path.dart' as path;

import 'arguments_parser.dart';

/// Umbrella method to run all checks
/// throws [InvalidArgumentException]
void validateArguments(ArgResults arguments) {
  checkRootFolderExistAndDirectory(arguments);
  checkPathsToAnalyzeNotEmpty(arguments);
  checkPathsExistAndDirectories(arguments);
}

void checkPathsToAnalyzeNotEmpty(ArgResults arguments) {
  if (arguments.rest.isEmpty) {
    throw const InvalidArgumentException(
        'Invalid number of directories. At least one must be specified');
  }
}

void checkPathsExistAndDirectories(ArgResults arguments) {
  final rootFolderPath = arguments[rootFolderName] as String;

  for (final relativePath in arguments.rest) {
    final absolutePath = path.join(rootFolderPath, relativePath);
    if (!Directory(absolutePath).existsSync()) {
      throw InvalidArgumentException(
          "$absolutePath doesn't exist or isn't a directory");
    }
  }
}

void checkRootFolderExistAndDirectory(ArgResults arguments) {
  final rootFolderPath = arguments[rootFolderName] as String;
  if (!Directory(rootFolderPath).existsSync()) {
    throw InvalidArgumentException(
        'Root folder $rootFolderPath does not exist or not a directory');
  }
}
