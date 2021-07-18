import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:path/path.dart';

import '../../../reporters.dart';
import '../../config_builder/config_builder.dart';
import '../../config_builder/models/analysis_options.dart';
import '../../utils/file_utils.dart';
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

    final unusedFiles = <String>{};

    for (final context in collection.contexts) {
      final analysisOptions = await analysisOptionsFromContext(context) ??
          await analysisOptionsFromFilePath(rootFolder);

      final contextConfig =
          ConfigBuilder.getUnusedFilesConfigFromOption(analysisOptions)
              .merge(config);
      final unusedFilesAnalysisConfig =
          ConfigBuilder.getUnusedFilesConfig(contextConfig, rootFolder);

      final contextFolders = folders
          .where((path) => normalize(join(rootFolder, path))
              .contains(context.contextRoot.root.path))
          .toList();

      final filePaths = extractDartFilesFromFolders(
        contextFolders,
        rootFolder,
        unusedFilesAnalysisConfig.globalExcludes,
      );

      unusedFiles.addAll(filePaths);

      final analyzedFiles =
          filePaths.intersection(context.contextRoot.analyzedFiles().toSet());

      for (final filePath in analyzedFiles) {
        final unit = await context.currentSession.getResolvedUnit2(filePath);
        unusedFiles.removeAll(_analyzeFile(filePath, unit));
      }

      final notAnalyzedFiles = filePaths.difference(analyzedFiles);

      for (final filePath in notAnalyzedFiles) {
        if (unusedFilesAnalysisConfig.analyzerExcludedPatterns
            .any((pattern) => pattern.matches(filePath))) {
          final unit = await resolveFile2(path: filePath);
          unusedFiles.removeAll(_analyzeFile(filePath, unit));
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

  Iterable<String> _analyzeFile(String filePath, SomeResolvedUnitResult unit) {
    if (unit is ResolvedUnitResult) {
      final visitor = UnusedFilesVisitor(filePath);
      unit.unit?.visitChildren(visitor);

      return visitor.paths;
    }

    return [];
  }
}
