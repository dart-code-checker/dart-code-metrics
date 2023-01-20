import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:path/path.dart';

import '../../config_builder/config_builder.dart';
import '../../config_builder/models/analysis_options.dart';
import '../../logger/logger.dart';
import '../../reporters/models/file_report.dart';
import '../../reporters/models/reporter.dart';
import '../../utils/analyzer_utils.dart';
import '../../utils/exclude_utils.dart';
import '../../utils/node_utils.dart';
import '../../utils/suppression.dart';
import 'lint_analysis_config.dart';
import 'lint_analysis_options_validator.dart';
import 'lint_config.dart';
import 'metrics/metrics_list/cyclomatic_complexity/cyclomatic_complexity_metric.dart';
import 'metrics/metrics_list/source_lines_of_code/source_lines_of_code_metric.dart';
import 'metrics/models/metric_value.dart';
import 'metrics/scope_visitor.dart';
import 'models/internal_resolved_unit_result.dart';
import 'models/issue.dart';
import 'models/lint_file_report.dart';
import 'models/report.dart';
import 'models/scoped_class_declaration.dart';
import 'models/scoped_function_declaration.dart';
import 'models/summary_lint_report_record.dart';
import 'reporters/lint_report_params.dart';
import 'reporters/reporter_factory.dart';
import 'utils/report_utils.dart';

/// The analyzer responsible for collecting lint reports.
class LintAnalyzer {
  final Logger? _logger;

  const LintAnalyzer([this._logger]);

  /// Returns a reporter for the given [name]. Use the reporter
  /// to convert analysis reports to console, JSON or other supported format.
  Reporter<FileReport, LintReportParams>? getReporter({
    required String name,
    required IOSink output,
    required String reportFolder,
  }) =>
      reporter(
        name: name,
        output: output,
        reportFolder: reportFolder,
      );

  /// Returns a lint report for analyzing given [result].
  /// The analysis is configured with the [config].
  LintFileReport? runPluginAnalysis(
    ResolvedUnitResult result,
    LintAnalysisConfig config,
    String rootFolder,
  ) {
    if (!isExcluded(result.path, config.globalExcludes)) {
      return _analyzeFile(
        result,
        config,
        rootFolder,
        filePath: result.path,
      );
    }

    return null;
  }

  /// Returns a list of lint reports for analyzing all files in the given [folders].
  /// The analysis is configured with the [config].
  Future<Iterable<LintFileReport>> runCliAnalysis(
    Iterable<String> folders,
    String rootFolder,
    LintConfig config, {
    String? sdkPath,
  }) async {
    final collection =
        createAnalysisContextCollection(folders, rootFolder, sdkPath);

    final analyzerResult = <LintFileReport>[];

    for (final context in collection.contexts) {
      final lintAnalysisConfig =
          _getAnalysisConfig(context, rootFolder, config);

      final report = LintAnalysisOptionsValidator.validateOptions(
        lintAnalysisConfig,
        rootFolder,
      );
      if (report != null) {
        analyzerResult.add(report);
      }

      if (config.shouldPrintConfig) {
        _logger?.printConfig(lintAnalysisConfig.toJson());
      }

      final filePaths = getFilePaths(
        folders,
        context,
        rootFolder,
        lintAnalysisConfig.globalExcludes,
      );

      final analyzedFiles =
          filePaths.intersection(context.contextRoot.analyzedFiles().toSet());

      final contextsLength = collection.contexts.length;
      final filesLength = analyzedFiles.length;
      final updateMessage = contextsLength == 1
          ? 'Analyzing $filesLength file(s)'
          : 'Analyzing ${collection.contexts.indexOf(context) + 1}/$contextsLength contexts with $filesLength file(s)';
      _logger?.progress.update(updateMessage);

      for (final filePath in analyzedFiles) {
        _logger?.infoVerbose('Analyzing $filePath');

        final unit = await context.currentSession.getResolvedUnit(filePath);
        if (unit is ResolvedUnitResult) {
          final result = _analyzeFile(
            unit,
            lintAnalysisConfig,
            rootFolder,
            filePath: filePath,
          );

          if (result != null) {
            _logger?.infoVerbose(
              'Analysis result: found ${result.issues.length} issues',
            );

            analyzerResult.add(result);
          }
        }
      }
    }

    return analyzerResult;
  }

  Iterable<SummaryLintReportRecord<Object>> getSummary(
    Iterable<LintFileReport> records,
  ) =>
      [
        SummaryLintReportRecord<Iterable<String>>(
          title: 'Scanned folders',
          value: scannedFolders(records),
        ),
        SummaryLintReportRecord<int>(
          title: 'Total scanned files',
          value: totalFiles(records),
        ),
        SummaryLintReportRecord<int>(
          title: 'Total lines of source code',
          value: totalSLOC(records),
        ),
        SummaryLintReportRecord<int>(
          title: 'Total classes',
          value: totalClasses(records),
        ),
        SummaryLintReportRecord<num>(
          title: 'Average Cyclomatic Number per line of code',
          value: averageCYCLO(records),
          violations:
              metricViolations(records, CyclomaticComplexityMetric.metricId),
        ),
        SummaryLintReportRecord<int>(
          title: 'Average Source Lines of Code per method',
          value: averageSLOC(records),
          violations:
              metricViolations(records, SourceLinesOfCodeMetric.metricId),
        ),
        SummaryLintReportRecord<String>(
          title: 'Total tech debt',
          value: totalTechDebt(records),
        ),
      ];

  LintAnalysisConfig _getAnalysisConfig(
    AnalysisContext context,
    String rootFolder,
    LintConfig config,
  ) {
    final analysisOptions = analysisOptionsFromContext(context) ??
        analysisOptionsFromFilePath(rootFolder, context);

    final contextConfig =
        ConfigBuilder.getLintConfigFromOptions(analysisOptions).merge(config);

    return ConfigBuilder.getLintAnalysisConfig(
      contextConfig,
      analysisOptions.folderPath ?? rootFolder,
    );
  }

  // ignore: long-method
  LintFileReport? _analyzeFile(
    ResolvedUnitResult result,
    LintAnalysisConfig config,
    String rootFolder, {
    String? filePath,
  }) {
    if (filePath == null || !_isSupported(result)) {
      return null;
    }

    final ignores = Suppression(
      result.content,
      result.lineInfo,
      supportsTypeLintIgnore: true,
    );
    final internalResult = InternalResolvedUnitResult(
      filePath,
      result.content,
      result.unit,
      result.lineInfo,
    );
    final relativePath = relative(filePath, from: rootFolder);

    final issues = <Issue>[];
    if (!isExcluded(filePath, config.rulesExcludes)) {
      issues.addAll(_checkOnCodeIssues(ignores, internalResult, config));
    }

    if (!isExcluded(filePath, config.metricsExcludes)) {
      final visitor = ScopeVisitor();
      internalResult.unit.visitChildren(visitor);

      final classMetrics = _checkClassMetrics(visitor, internalResult, config);
      final fileMetrics = _checkFileMetrics(visitor, internalResult, config);
      final functionMetrics =
          _checkFunctionMetrics(visitor, internalResult, config);
      final antiPatterns = _checkOnAntiPatterns(
        ignores,
        internalResult,
        config,
        classMetrics,
        functionMetrics,
      );

      return LintFileReport(
        path: filePath,
        relativePath: relativePath,
        file: fileMetrics,
        classes: Map.unmodifiable(
          classMetrics.map((key, value) => MapEntry(key.name, value)),
        ),
        functions: Map.unmodifiable(
          functionMetrics.map((key, value) => MapEntry(key.fullName, value)),
        ),
        issues: issues,
        antiPatternCases: antiPatterns,
      );
    }

    return LintFileReport.onlyIssues(
      path: filePath,
      relativePath: relativePath,
      issues: issues,
    );
  }

  Iterable<Issue> _checkOnCodeIssues(
    Suppression ignores,
    InternalResolvedUnitResult source,
    LintAnalysisConfig config,
  ) =>
      config.codeRules
          .where((rule) =>
              !ignores.isSuppressed(rule.id) &&
              isIncluded(
                source.path,
                createAbsolutePatterns(rule.includes, config.rootFolder),
              ) &&
              !isExcluded(
                source.path,
                createAbsolutePatterns(rule.excludes, config.rootFolder),
              ))
          .expand(
            (rule) =>
                rule.check(source).where((issue) => !ignores.isSuppressedAt(
                      issue.ruleId,
                      issue.location.start.line,
                    )),
          )
          .toList();

  Iterable<Issue> _checkOnAntiPatterns(
    Suppression ignores,
    InternalResolvedUnitResult source,
    LintAnalysisConfig config,
    Map<ScopedClassDeclaration, Report> classMetrics,
    Map<ScopedFunctionDeclaration, Report> functionMetrics,
  ) =>
      config.antiPatterns
          .where((pattern) =>
              !ignores.isSuppressed(pattern.id) &&
              !isExcluded(
                source.path,
                createAbsolutePatterns(pattern.excludes, config.rootFolder),
              ))
          .expand((pattern) => pattern
              .check(source, classMetrics, functionMetrics)
              .where((issue) => !ignores.isSuppressedAt(
                    issue.ruleId,
                    issue.location.start.line,
                  )))
          .toList();

  Map<ScopedClassDeclaration, Report> _checkClassMetrics(
    ScopeVisitor visitor,
    InternalResolvedUnitResult source,
    LintAnalysisConfig config,
  ) {
    final classRecords = <ScopedClassDeclaration, Report>{};

    for (final classDeclaration in visitor.classes) {
      final metrics = <MetricValue>[];

      for (final metric in config.classesMetrics) {
        if (metric.supports(
          classDeclaration.declaration,
          visitor.classes,
          visitor.functions,
          source,
          metrics,
        )) {
          metrics.add(metric.compute(
            classDeclaration.declaration,
            visitor.classes,
            visitor.functions,
            source,
            metrics,
          ));
        }
      }

      final report = Report(
        location: nodeLocation(
          node: classDeclaration.declaration,
          source: source,
        ),
        declaration: classDeclaration.declaration,
        metrics: metrics,
      );

      classRecords[classDeclaration] = report;
    }

    return classRecords;
  }

  Report _checkFileMetrics(
    ScopeVisitor visitor,
    InternalResolvedUnitResult source,
    LintAnalysisConfig config,
  ) {
    final metrics = <MetricValue>[];

    for (final metric in config.fileMetrics) {
      if (metric.supports(
        source.unit,
        visitor.classes,
        visitor.functions,
        source,
        metrics,
      )) {
        metrics.add(metric.compute(
          source.unit,
          visitor.classes,
          visitor.functions,
          source,
          metrics,
        ));
      }
    }

    return Report(
      location: nodeLocation(node: source.unit, source: source),
      declaration: source.unit,
      metrics: metrics,
    );
  }

  Map<ScopedFunctionDeclaration, Report> _checkFunctionMetrics(
    ScopeVisitor visitor,
    InternalResolvedUnitResult source,
    LintAnalysisConfig config,
  ) {
    final functionRecords = <ScopedFunctionDeclaration, Report>{};

    for (final function in visitor.functions) {
      final metrics = <MetricValue>[];

      for (final metric in config.methodsMetrics) {
        if (metric.supports(
          function.declaration,
          visitor.classes,
          visitor.functions,
          source,
          metrics,
        )) {
          metrics.add(metric.compute(
            function.declaration,
            visitor.classes,
            visitor.functions,
            source,
            metrics,
          ));
        }
      }

      functionRecords[function] = Report(
        location: nodeLocation(node: function.declaration, source: source),
        declaration: function.declaration,
        metrics: metrics,
      );
    }

    return functionRecords;
  }

  bool _isSupported(FileResult result) =>
      result.path.endsWith('.dart') &&
      !result.path.endsWith('.g.dart') &&
      !result.path.endsWith('.freezed.dart');
}
