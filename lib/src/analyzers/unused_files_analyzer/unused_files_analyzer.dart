import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:path/path.dart';

import '../../config_builder/config_builder.dart';
import '../../config_builder/models/analysis_options.dart';
import '../../logger/logger.dart';
import '../../reporters/models/reporter.dart';
import '../../utils/analyzer_utils.dart';
import '../../utils/suppression.dart';
import 'models/unused_files_file_report.dart';
import 'reporters/reporter_factory.dart';
import 'reporters/unused_files_report_params.dart';
import 'unused_files_analysis_config.dart';
import 'unused_files_config.dart';
import 'unused_files_visitor.dart';

/// The analyzer responsible for collecting unused files reports.
class UnusedFilesAnalyzer {
  static const _ignoreName = 'unused-files';

  final Logger? _logger;

  const UnusedFilesAnalyzer([this._logger]);

  /// Returns a reporter for the given [name]. Use the reporter
  /// to convert analysis reports to console, JSON or other supported format.
  Reporter<UnusedFilesFileReport, UnusedFilesReportParams>? getReporter({
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
      final unusedFilesAnalysisConfig =
          _getAnalysisConfig(context, rootFolder, config);

      if (config.shouldPrintConfig) {
        _logger?.printConfig(unusedFilesAnalysisConfig.toJson());
      }

      final filePaths = getFilePaths(
        folders,
        context,
        rootFolder,
        unusedFilesAnalysisConfig.globalExcludes,
      );

      unusedFiles.addAll(filePaths);

      final analyzedFiles =
          filePaths.intersection(context.contextRoot.analyzedFiles().toSet());
      for (final filePath in analyzedFiles) {
        _logger?.infoVerbose('Analyzing $filePath');

        final unit = await context.currentSession.getResolvedUnit(filePath);
        unusedFiles.removeAll(_analyzeFile(filePath, unit, config.isMonorepo));
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

  UnusedFilesAnalysisConfig _getAnalysisConfig(
    AnalysisContext context,
    String rootFolder,
    UnusedFilesConfig config,
  ) {
    final analysisOptions = analysisOptionsFromContext(context) ??
        analysisOptionsFromFilePath(rootFolder, context);

    final contextConfig =
        ConfigBuilder.getUnusedFilesConfigFromOption(analysisOptions)
            .merge(config);

    return ConfigBuilder.getUnusedFilesConfig(contextConfig, rootFolder);
  }

  Iterable<String> _analyzeFile(
    String filePath,
    SomeResolvedUnitResult unit,
    bool ignoreExports,
  ) {
    if (unit is ResolvedUnitResult) {
      final suppression = Suppression(unit.content, unit.lineInfo);
      final isSuppressed = suppression.isSuppressed(_ignoreName);
      if (isSuppressed) {
        return [filePath];
      }

      final visitor =
          UnusedFilesVisitor(filePath, ignoreExports: ignoreExports);
      unit.unit.visitChildren(visitor);

      return visitor.paths;
    }

    return [];
  }
}
