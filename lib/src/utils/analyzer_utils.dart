// ignore_for_file: implementation_imports
import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context.dart';
import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/context_locator.dart';
import 'package:analyzer/file_system/file_system.dart' hide File;
import 'package:analyzer/file_system/overlay_file_system.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:analyzer/src/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/src/dart/analysis/byte_store.dart';
import 'package:analyzer/src/dart/analysis/file_byte_store.dart';
import 'package:file/local.dart';
import 'package:glob/glob.dart';
import 'package:path/path.dart';

import 'exclude_utils.dart';

AnalysisContextCollection createAnalysisContextCollection(
  Iterable<String> folders,
  String rootFolder,
  String? sdkPath,
) {
  final includedPaths =
      folders.map((path) => normalize(join(rootFolder, path))).toList();
  final resourceProvider = _prepareAnalysisOptions(includedPaths);

  return AnalysisContextCollectionImpl(
    sdkPath: sdkPath,
    includedPaths: includedPaths,
    resourceProvider: resourceProvider,
    byteStore: createByteStore(resourceProvider),
  );
}

Set<String> getFilePaths(
  Iterable<String> folders,
  AnalysisContext context,
  String rootFolder,
  Iterable<Glob> excludes,
) {
  final rootPath = context.contextRoot.root.path;

  final contextFolders = folders.where((path) {
    final folderPath = normalize(join(rootFolder, path));

    return folderPath == rootPath || folderPath.startsWith('$rootPath/');
  }).toList();

  return _extractDartFilesFromFolders(contextFolders, rootFolder, excludes);
}

/// If the state location can be accessed, return the file byte store,
/// otherwise return the memory byte store.
ByteStore createByteStore(ResourceProvider resourceProvider) {
  const miB = 1024 * 1024 /*1 MiB*/;
  const giB = 1024 * 1024 * 1024 /*1 GiB*/;

  const memoryCacheSize = miB * 128;

  final stateLocation = resourceProvider.getStateLocation('.dart-code-metrics');
  if (stateLocation != null) {
    return MemoryCachingByteStore(
      EvictingFileByteStore(stateLocation.path, giB),
      memoryCacheSize,
    );
  }

  return MemoryCachingByteStore(NullByteStore(), memoryCacheSize);
}

Set<String> _extractDartFilesFromFolders(
  Iterable<String> folders,
  String rootFolder,
  Iterable<Glob> globalExcludes,
) =>
    folders
        .expand((fileSystemEntity) => (fileSystemEntity.endsWith('.dart')
                ? Glob(fileSystemEntity)
                : Glob('$fileSystemEntity/**.dart'))
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
            .map((entity) => normalize(entity.path)))
        .toSet();

ResourceProvider _prepareAnalysisOptions(List<String> includedPaths) {
  final resourceProvider =
      OverlayResourceProvider(PhysicalResourceProvider.INSTANCE);

  final contextLocator = ContextLocator(resourceProvider: resourceProvider);
  final roots = contextLocator
      .locateRoots(includedPaths: includedPaths, excludedPaths: []);

  for (final root in roots) {
    final path = root.optionsFile?.path;
    if (path != null) {
      resourceProvider.setOverlay(
        path,
        content: '',
        modificationStamp: DateTime.now().millisecondsSinceEpoch,
      );
    }
  }

  return resourceProvider;
}
