import 'dart:io';

import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:path/path.dart';

import '../../config_builder/config_builder.dart';
import '../../config_builder/models/analysis_options.dart';
import '../../reporters/models/reporter.dart';
import '../../utils/analyzer_utils.dart';
import '../../utils/file_utils.dart';
import 'models/unused_files_file_report.dart';
import 'reporters/reporter_factory.dart';
import 'reporters/unused_files_report_params.dart';
import 'unused_files_config.dart';
import 'unused_files_visitor.dart';

/// The analyzer responsible for collecting unused files reports.
class UnusedFilesAnalyzer {
  const UnusedFilesAnalyzer();

  /// Returns a reporter for the given [name]. Use the reporter
  /// to convert analysis reports to console, JSON or other supported format.
  Reporter<UnusedFilesFileReport, void, UnusedFilesReportParams>? getReporter({
    required String name,
    required IOSink output,
  }) =>
      reporter(
        name: name,
        output: output,
      );

  /// Returns a list of unused files reports
  /// for analyzing all files in the given [folders].
  /// The analysis is configured with the [config].
  Future<Iterable<UnusedFilesFileReport>> runCliAnalysis(
    Iterable<String> folders,
    String rootFolder,
    UnusedFilesConfig config, {
    String? sdkPath,
  }) async {
    final collection =
        createAnalysisContextCollection(folders, rootFolder, sdkPath);

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
              .startsWith(context.contextRoot.root.path))
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
        final unit = await context.currentSession.getResolvedUnit(filePath);
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

  void deleteAllUnusedFiles(Iterable<UnusedFilesFileReport> reports) {
    for (final report in reports) {
      File(report.path).deleteSync();
    }
  }

  Iterable<String> _analyzeFile(String filePath, SomeResolvedUnitResult unit) {
    if (unit is ResolvedUnitResult) {
      final visitor = UnusedFilesVisitor(filePath);
      unit.unit.visitChildren(visitor);

      return visitor.paths;
    }

    return [];
  }
}
