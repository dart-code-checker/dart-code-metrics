import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:file/local.dart';
import 'package:glob/glob.dart';
import 'package:path/path.dart';

import '../../../reporters.dart';
import '../../utils/exclude_utils.dart';
import 'models/unused_files_file_report.dart';
import 'reporters/reporter_factory.dart';
import 'unused_files_config.dart';
import 'unused_files_visitor.dart';

class UnusedFilesAnalyzer {
  const UnusedFilesAnalyzer();

  Reporter? getReporter({
    required String name,
    required IOSink output,
  }) =>
      reporter(
        name: name,
        output: output,
      );

  Future<Iterable<UnusedFilesFileReport>> runCliAnalysis(
    Iterable<String> folders,
    String rootFolder,
    UnusedFilesConfig config,
  ) async {
    final collection = AnalysisContextCollection(
      includedPaths:
          folders.map((path) => normalize(join(rootFolder, path))).toList(),
      resourceProvider: PhysicalResourceProvider.INSTANCE,
    );

    final filePaths = folders
        .expand((directory) => Glob('$directory/**.dart')
            .listFileSystemSync(
              const LocalFileSystem(),
              root: rootFolder,
              followLinks: false,
            )
            .whereType<File>()
            .where((entity) => !isExcluded(
                  relative(entity.path, from: rootFolder),
                  config.globalExcludes,
                ))
            .map((entity) => entity.path))
        .toSet();

    final unusedFiles = filePaths.toSet();

    for (final context in collection.contexts) {
      final analyzedFiles =
          filePaths.intersection(context.contextRoot.analyzedFiles().toSet());

      for (final filePath in analyzedFiles) {
        final unit = await context.currentSession.getResolvedUnit2(filePath);
        if (unit is ResolvedUnitResult) {
          final visitor = UnusedFilesVisitor(filePath);
          unit.unit?.visitChildren(visitor);

          unusedFiles.removeAll(visitor.paths);
        }
      }
    }

    return unusedFiles.map((path) {
      final relativePath = relative(path, from: rootFolder);

      return UnusedFilesFileReport(
        path: path,
        relativePath: relativePath,
      );
    }).toSet();
  }
}
