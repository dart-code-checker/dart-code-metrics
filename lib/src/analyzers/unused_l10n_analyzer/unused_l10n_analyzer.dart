import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
// ignore: implementation_imports
import 'package:analyzer/src/dart/element/element.dart';
import 'package:path/path.dart';
import 'package:source_span/source_span.dart';

import '../../config_builder/config_builder.dart';
import '../../config_builder/models/analysis_options.dart';
import '../../logger/logger.dart';
import '../../reporters/models/reporter.dart';
import '../../utils/analyzer_utils.dart';
import 'models/unused_l10n_file_report.dart';
import 'models/unused_l10n_issue.dart';
import 'reporters/reporter_factory.dart';
import 'reporters/unused_l10n_report_params.dart';
import 'unused_l10n_analysis_config.dart';
import 'unused_l10n_config.dart';
import 'unused_l10n_visitor.dart';

/// The analyzer responsible for collecting unused localization reports.
class UnusedL10nAnalyzer {
  final Logger? _logger;

  const UnusedL10nAnalyzer([this._logger]);

  /// Returns a reporter for the given [name]. Use the reporter
  /// to convert analysis reports to console, JSON or other supported format.
  Reporter<UnusedL10nFileReport, UnusedL10NReportParams>? getReporter({
    required String name,
    required IOSink output,
  }) =>
      reporter(
        name: name,
        output: output,
      );

  /// Returns a list of unused localization reports
  /// for analyzing all files in the given [folders].
  /// The analysis is configured with the [config].
  Future<Iterable<UnusedL10nFileReport>> runCliAnalysis(
    Iterable<String> folders,
    String rootFolder,
    UnusedL10nConfig config, {
    String? sdkPath,
  }) async {
    final collection =
        createAnalysisContextCollection(folders, rootFolder, sdkPath);

    final localizationUsages = <ClassElement, Set<String>>{};

    for (final context in collection.contexts) {
      final unusedLocalizationAnalysisConfig =
          _getAnalysisConfig(context, rootFolder, config);

      if (config.shouldPrintConfig) {
        _logger?.printConfig(unusedLocalizationAnalysisConfig.toJson());
      }

      final filePaths = getFilePaths(
        folders,
        context,
        rootFolder,
        unusedLocalizationAnalysisConfig.globalExcludes,
      );

      final analyzedFiles =
          filePaths.intersection(context.contextRoot.analyzedFiles().toSet());

      for (final filePath in analyzedFiles) {
        _logger?.infoVerbose('Analyzing $filePath');

        final unit = await context.currentSession.getResolvedUnit(filePath);

        _analyzeFile(unit, unusedLocalizationAnalysisConfig.classPattern)
            .forEach((classElement, usages) {
          localizationUsages.update(
            classElement,
            (value) => value..addAll(usages),
            ifAbsent: () => usages,
          );
        });
      }
    }

    return _checkUnusedL10n(localizationUsages, rootFolder);
  }

  UnusedL10nAnalysisConfig _getAnalysisConfig(
    AnalysisContext context,
    String rootFolder,
    UnusedL10nConfig config,
  ) {
    final analysisOptions = analysisOptionsFromContext(context) ??
        analysisOptionsFromFilePath(rootFolder, context);

    final contextConfig =
        ConfigBuilder.getUnusedL10nConfigFromOption(analysisOptions)
            .merge(config);

    return ConfigBuilder.getUnusedL10nConfig(contextConfig, rootFolder);
  }

  Map<ClassElement, Set<String>> _analyzeFile(
    SomeResolvedUnitResult unit,
    RegExp classPattern,
  ) {
    if (unit is ResolvedUnitResult) {
      final visitor = UnusedL10nVisitor(classPattern);
      unit.unit.visitChildren(visitor);

      return visitor.invocations;
    }

    return {};
  }

  Iterable<UnusedL10nFileReport> _checkUnusedL10n(
    Map<ClassElement, Iterable<String>> localizationUsages,
    String rootFolder,
  ) {
    final unusedLocalizationIssues = <UnusedL10nFileReport>[];

    localizationUsages.forEach((classElement, usages) {
      final report = _getUnusedReports(
        classElement,
        usages,
        rootFolder,
      );
      if (report != null) {
        unusedLocalizationIssues.add(report);
      }

      final hasCustomSupertype = classElement.allSupertypes.length > 1;
      if (hasCustomSupertype) {
        final supertype = classElement.supertype;
        if (supertype is InterfaceType) {
          final report = _getUnusedReports(
            // ignore: deprecated_member_use
            supertype.element2,
            usages,
            rootFolder,
            overriddenClassName: classElement.name,
          );
          if (report != null) {
            unusedLocalizationIssues.add(report);
          }
        }
      }
    });

    return unusedLocalizationIssues;
  }

  UnusedL10nFileReport? _getUnusedReports(
    InterfaceElement classElement,
    Iterable<String> usages,
    String rootFolder, {
    String? overriddenClassName,
  }) {
    final unit = classElement.thisOrAncestorOfType<CompilationUnitElement>();
    if (unit == null) {
      return null;
    }

    final lineInfo = unit.lineInfo;
    // ignore: unnecessary_null_comparison
    if (lineInfo == null) {
      return null;
    }

    final accessorSourceSpans = _getUnusedAccessors(classElement, usages, unit);
    final methodSourceSpans = _getUnusedMethods(classElement, usages, unit);

    final filePath = unit.source.toString();
    final relativePath = relative(filePath, from: rootFolder);

    final issues = [
      ...accessorSourceSpans,
      ...methodSourceSpans,
    ];

    if (issues.isNotEmpty) {
      return UnusedL10nFileReport(
        path: filePath,
        relativePath: relativePath,
        className: overriddenClassName ?? classElement.name,
        issues: issues,
      );
    }

    return null;
  }

  Iterable<UnusedL10nIssue> _getUnusedAccessors(
    InterfaceElement classElement,
    Iterable<String> usages,
    CompilationUnitElement unit,
  ) {
    final unusedAccessors = classElement.accessors
        .where((field) => !field.isPrivate && !usages.contains(field.name))
        .map((field) => field.isSynthetic ? field.nonSynthetic : field);

    return unusedAccessors
        .map((accessor) => _createL10nIssue(accessor as ElementImpl, unit))
        .toList();
  }

  Iterable<UnusedL10nIssue> _getUnusedMethods(
    InterfaceElement classElement,
    Iterable<String> usages,
    CompilationUnitElement unit,
  ) {
    final unusedMethods = classElement.methods
        .where((method) => !method.isPrivate && !usages.contains(method.name))
        .map((method) => method.isSynthetic ? method.nonSynthetic : method);

    return unusedMethods
        .map((method) => _createL10nIssue(method as ElementImpl, unit))
        .toList();
  }

  UnusedL10nIssue _createL10nIssue(
    ElementImpl element,
    CompilationUnitElement unit,
  ) {
    final offset = element.codeOffset!;
    final lineInfo = unit.lineInfo;
    final offsetLocation = lineInfo.getLocation(offset);

    final sourceUrl = element.source!.uri;

    final name = element is MethodElement
        ? '${element.displayName}(${(element as MethodElement).parameters.join(', ')})'
        : element.displayName;

    return UnusedL10nIssue(
      memberName: name,
      location: SourceLocation(
        offset,
        sourceUrl: sourceUrl,
        line: offsetLocation.lineNumber,
        column: offsetLocation.columnNumber,
      ),
    );
  }
}
