import 'dart:io';

import 'package:file/local.dart';
import 'package:glob/glob.dart';
import 'package:path/path.dart';

import 'exclude_utils.dart';

Set<String> extractDartFilesFromFolders(
  Iterable<String> folders,
  String rootFolder,
  Iterable<Glob> globalExcludes,
) =>
    folders
        .expand((directory) => Glob('$directory/**.dart')
            .listFileSystemSync(
              const LocalFileSystem(),
              root: rootFolder,
              followLinks: false,
            )
            .whereType<File>()
            .where((entity) => !isExcluded(
                  relative(entity.path, from: rootFolder),
                  globalExcludes,
                ))
            .map((entity) => entity.path))
        .toSet();
