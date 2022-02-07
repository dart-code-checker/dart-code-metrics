import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/element/element.dart';
// ignore: implementation_imports
import 'package:analyzer/src/dart/element/element.dart';
import 'package:glob/glob.dart';
import 'package:path/path.dart';
import 'package:source_span/source_span.dart';

import '../../config_builder/config_builder.dart';
import '../../config_builder/models/analysis_options.dart';
import '../../reporters/models/reporter.dart';
import '../../utils/analyzer_utils.dart';
import '../../utils/file_utils.dart';
import 'models/file_elements_usage.dart';
import 'models/unused_code_file_report.dart';
import 'models/unused_code_issue.dart';
import 'public_code_visitor.dart';
import 'reporters/reporter_factory.dart';
import 'reporters/unused_code_report_params.dart';
import 'unused_code_analysis_config.dart';
import 'unused_code_config.dart';
import 'used_code_visitor.dart';

/// The analyzer responsible for collecting unused code reports.
class UnusedCodeAnalyzer {
  const UnusedCodeAnalyzer();

  /// Returns a reporter for the given [name]. Use the reporter
  /// to convert analysis reports to console, JSON or other supported format.
  Reporter<UnusedCodeFileReport, void, UnusedCodeReportParams>? getReporter({
    required String name,
    required IOSink output,
  }) =>
      reporter(
        name: name,
        output: output,
      );

  /// Returns a list of unused code reports
  /// for analyzing all files in the given [folders].
  /// The analysis is configured with the [config].
  Future<Iterable<UnusedCodeFileReport>> runCliAnalysis(
    Iterable<String> folders,
    String rootFolder,
    UnusedCodeConfig config, {
    String? sdkPath,
  }) async {
    final collection =
        createAnalysisContextCollection(folders, rootFolder, sdkPath);

    final codeUsages = FileElementsUsage();
    final publicCode = <String, Set<Element>>{};

    for (final context in collection.contexts) {
      final unusedCodeAnalysisConfig =
          await _getAnalysisConfig(context, rootFolder, config);

      final excludes = unusedCodeAnalysisConfig.globalExcludes
          .followedBy(unusedCodeAnalysisConfig.analyzerExcludedPatterns);
      final filePaths = _getFilePaths(folders, context, rootFolder, excludes);

      final analyzedFiles =
          filePaths.intersection(context.contextRoot.analyzedFiles().toSet());
      for (final filePath in analyzedFiles) {
        final unit = await context.currentSession.getResolvedUnit(filePath);

        final codeUsage = _analyzeFileCodeUsages(unit);
        if (codeUsage != null) {
          codeUsages.merge(codeUsage);
        }

        publicCode[filePath] = _analyzeFilePublicCode(unit);
      }

      final notAnalyzedFiles = filePaths.difference(analyzedFiles);
      for (final filePath in notAnalyzedFiles) {
        if (excludes.any((pattern) => pattern.matches(filePath))) {
          final unit = await resolveFile2(path: filePath);

          final codeUsage = _analyzeFileCodeUsages(unit);
          if (codeUsage != null) {
            codeUsages.merge(codeUsage);
          }
        }
      }
    }

    if (!config.isMonorepo) {
      codeUsages.exports.forEach(publicCode.remove);
    }

    return _getReports(codeUsages, publicCode, rootFolder);
  }

  Future<UnusedCodeAnalysisConfig> _getAnalysisConfig(
    AnalysisContext context,
    String rootFolder,
    UnusedCodeConfig config,
  ) async {
    final analysisOptions = await analysisOptionsFromContext(context) ??
        await analysisOptionsFromFilePath(rootFolder);

    final contextConfig =
        ConfigBuilder.getUnusedCodeConfigFromOption(analysisOptions)
            .merge(config);

    return ConfigBuilder.getUnusedCodeConfig(contextConfig, rootFolder);
  }

  Set<String> _getFilePaths(
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

  FileElementsUsage? _analyzeFileCodeUsages(SomeResolvedUnitResult unit) {
    if (unit is ResolvedUnitResult) {
      final visitor = UsedCodeVisitor();
      unit.unit.visitChildren(visitor);

      return visitor.fileElementsUsage;
    }

    return null;
  }

  Set<Element> _analyzeFilePublicCode(SomeResolvedUnitResult unit) {
    if (unit is ResolvedUnitResult) {
      final visitor = PublicCodeVisitor();
      unit.unit.visitChildren(visitor);

      return visitor.topLevelElements;
    }

    return {};
  }

  Iterable<UnusedCodeFileReport> _getReports(
    FileElementsUsage codeUsages,
    Map<String, Set<Element>> publicCodeElements,
    String rootFolder,
  ) {
    final unusedCodeReports = <UnusedCodeFileReport>[];

    publicCodeElements.forEach((path, elements) {
      final issues = <UnusedCodeIssue>[];

      for (final element in elements) {
        if (_isUnused(codeUsages, path, element)) {
          final unit = element.thisOrAncestorOfType<CompilationUnitElement>();
          if (unit != null) {
            issues.add(_createUnusedCodeIssue(element as ElementImpl, unit));
          }
        }
      }

      final relativePath = relative(path, from: rootFolder);

      if (issues.isNotEmpty) {
        unusedCodeReports.add(UnusedCodeFileReport(
          path: path,
          relativePath: relativePath,
          issues: issues,
        ));
      }
    });

    return unusedCodeReports;
  }

  bool _isUsed(Element usedElement, Element element) =>
      element == usedElement ||
      element is PropertyInducingElement && element.getter == usedElement;

  bool _isUnused(
    FileElementsUsage codeUsages,
    String path,
    Element element,
  ) =>
      !codeUsages.elements.any(
        (usedElement) => _isUsed(usedElement, element),
      ) &&
      !codeUsages.usedExtensions.any(
        (usedElement) => _isUsed(usedElement, element),
      ) &&
      !codeUsages.prefixMap.values.any(
        (usage) =>
            usage.paths.contains(path) &&
            usage.elements.any((usedElement) =>
                _isUsed(usedElement, element) ||
                (usedElement.name == element.name &&
                    usedElement.kind == element.kind)),
      );

  UnusedCodeIssue _createUnusedCodeIssue(
    ElementImpl element,
    CompilationUnitElement unit,
  ) {
    final offset = element.codeOffset!;

    final lineInfo = unit.lineInfo!;
    final offsetLocation = lineInfo.getLocation(offset);

    final sourceUrl = element.source!.uri;

    return UnusedCodeIssue(
      declarationName: element.displayName,
      declarationType: element.kind.displayName,
      location: SourceLocation(
        offset,
        sourceUrl: sourceUrl,
        line: offsetLocation.lineNumber,
        column: offsetLocation.columnNumber,
      ),
    );
  }
}
