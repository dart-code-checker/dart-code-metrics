import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/element/element.dart';
// ignore: implementation_imports
import 'package:analyzer/src/dart/element/element.dart';
import 'package:path/path.dart';
import 'package:source_span/source_span.dart';

import '../../config_builder/config_builder.dart';
import '../../config_builder/models/analysis_options.dart';
import '../../logger/logger.dart';
import '../../reporters/models/reporter.dart';
import '../../utils/analyzer_utils.dart';
import '../../utils/suppression.dart';
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
  static const _ignoreName = 'unused-code';

  final Logger? _logger;

  const UnusedCodeAnalyzer([this._logger]);

  /// Returns a reporter for the given [name]. Use the reporter
  /// to convert analysis reports to console, JSON or other supported format.
  Reporter<UnusedCodeFileReport, UnusedCodeReportParams>? getReporter({
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
          _getAnalysisConfig(context, rootFolder, config);

      if (config.shouldPrintConfig) {
        _logger?.printConfig(unusedCodeAnalysisConfig.toJson());
      }

      final filePaths = getFilePaths(
        folders,
        context,
        rootFolder,
        unusedCodeAnalysisConfig.globalExcludes,
      );

      final analyzedFiles =
          filePaths.intersection(context.contextRoot.analyzedFiles().toSet());

      final contextsLength = collection.contexts.length;
      final filesLength = analyzedFiles.length;
      final updateMessage = contextsLength == 1
          ? 'Checking unused code for $filesLength file(s)'
          : 'Checking unused code for ${collection.contexts.indexOf(context) + 1}/$contextsLength contexts with $filesLength file(s)';
      _logger?.progress.update(updateMessage);

      for (final filePath in analyzedFiles) {
        _logger?.infoVerbose('Analyzing $filePath');

        final unit = await context.currentSession.getResolvedUnit(filePath);

        final codeUsage = _analyzeFileCodeUsages(unit);
        if (codeUsage != null) {
          codeUsages.merge(codeUsage);
        }

        if (!unusedCodeAnalysisConfig.analyzerExcludedPatterns
            .any((pattern) => pattern.matches(filePath))) {
          publicCode[filePath] = _analyzeFilePublicCode(unit);
        }
      }
    }

    if (!config.isMonorepo) {
      _logger?.infoVerbose(
        'Removing globally exported files with code usages from the analysis: ${codeUsages.exports.length}',
      );
      codeUsages.exports.forEach(publicCode.remove);
    }

    return _getReports(codeUsages, publicCode, rootFolder);
  }

  UnusedCodeAnalysisConfig _getAnalysisConfig(
    AnalysisContext context,
    String rootFolder,
    UnusedCodeConfig config,
  ) {
    final analysisOptions = analysisOptionsFromContext(context) ??
        analysisOptionsFromFilePath(rootFolder, context);

    final contextConfig =
        ConfigBuilder.getUnusedCodeConfigFromOption(analysisOptions)
            .merge(config);

    return ConfigBuilder.getUnusedCodeConfig(contextConfig, rootFolder);
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
      final suppression = Suppression(unit.content, unit.lineInfo);
      final isSuppressed = suppression.isSuppressed(_ignoreName);
      if (isSuppressed) {
        return {};
      }

      final visitor = PublicCodeVisitor(suppression, _ignoreName);
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
      _isEqualElements(usedElement, element) ||
      element is PropertyInducingElement &&
          _isEqualElements(usedElement, element.getter);

  bool _isEqualElements(Element left, Element? right) {
    if (left == right) {
      return true;
    }

    final usedLibrary = left.library;
    final declaredSource = right?.librarySource;

    // This is a hack to fix incorrect libraries resolution.
    // Should be removed after new analyzer version is available.
    // see: https://github.com/dart-lang/sdk/issues/49182
    return usedLibrary != null &&
        declaredSource != null &&
        left.name == right?.name &&
        usedLibrary.units
            .map((unit) => unit.source.fullName)
            .contains(declaredSource.fullName);
  }

  bool _isUnused(FileElementsUsage codeUsages, String path, Element element) =>
      !codeUsages.conditionalElements.entries.any((entry) =>
          entry.key.contains(path) &&
          entry.value.any((usedElement) =>
              _isUsed(usedElement, element) ||
              (usedElement.name == element.name &&
                  usedElement.kind == element.kind))) &&
      !codeUsages.elements
          .any((usedElement) => _isUsed(usedElement, element)) &&
      !codeUsages.usedExtensions
          .any((usedElement) => _isUsed(usedElement, element));

  UnusedCodeIssue _createUnusedCodeIssue(
    ElementImpl element,
    CompilationUnitElement unit,
  ) {
    final offset = element.codeOffset!;
    final lineInfo = unit.lineInfo;
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
