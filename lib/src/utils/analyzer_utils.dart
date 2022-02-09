// ignore_for_file: implementation_imports
import 'package:analyzer/dart/analysis/analysis_context.dart';
import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:analyzer/src/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/src/dart/analysis/byte_store.dart';
import 'package:analyzer/src/dart/analysis/file_byte_store.dart';
import 'package:glob/glob.dart';
import 'package:path/path.dart';

import 'file_utils.dart';

AnalysisContextCollection createAnalysisContextCollection(
  Iterable<String> folders,
  String rootFolder,
  String? sdkPath,
) {
  final resourceProvider = PhysicalResourceProvider.INSTANCE;

  return AnalysisContextCollectionImpl(
    sdkPath: sdkPath,
    includedPaths:
        folders.map((path) => normalize(join(rootFolder, path))).toList(),
    resourceProvider: resourceProvider,
    byteStore: _createByteStore(resourceProvider),
  );
}

Set<String> getFilePaths(
  Iterable<String> folders,
  AnalysisContext context,
  String rootFolder,
  Iterable<Glob> excludes,
) {
  final contextFolders = folders.where((path) {
    final newPath = normalize(join(rootFolder, path));

    return newPath == context.contextRoot.root.path ||
        context.contextRoot.root.path.startsWith('$newPath/');
  }).toList();

  return extractDartFilesFromFolders(contextFolders, rootFolder, excludes);
}

/// If the state location can be accessed, return the file byte store,
/// otherwise return the memory byte store.
ByteStore _createByteStore(PhysicalResourceProvider resourceProvider) {
  const M = 1024 * 1024 /*1 MiB*/;
  const G = 1024 * 1024 * 1024 /*1 GiB*/;

  const memoryCacheSize = M * 128;

  final stateLocation = resourceProvider.getStateLocation('.dart-code-metrics');
  if (stateLocation != null) {
    return MemoryCachingByteStore(
      EvictingFileByteStore(stateLocation.path, G),
      memoryCacheSize,
    );
  }

  return MemoryCachingByteStore(NullByteStore(), memoryCacheSize);
}
