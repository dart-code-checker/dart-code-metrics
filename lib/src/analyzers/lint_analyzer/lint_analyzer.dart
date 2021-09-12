import 'dart:io';

import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:path/path.dart';

import '../../config_builder/config_builder.dart';
import '../../config_builder/models/analysis_options.dart';
import '../../reporters/models/reporter.dart';
import '../../utils/analyzer_utils.dart';
import '../../utils/exclude_utils.dart';
import '../../utils/file_utils.dart';
import '../../utils/node_utils.dart';
import 'lint_analysis_config.dart';
import 'lint_config.dart';
import 'metrics/models/metric_value.dart';
import 'metrics/scope_visitor.dart';
import 'models/internal_resolved_unit_result.dart';
import 'models/issue.dart';
import 'models/lint_file_report.dart';
import 'models/report.dart';
import 'models/scoped_class_declaration.dart';
import 'models/scoped_function_declaration.dart';
import 'models/suppression.dart';
import 'reporters/reporter_factory.dart';

class LintAnalyzer {
  const LintAnalyzer();

  Reporter? getReporter({
    required String name,
    required IOSink output,
    required String reportFolder,
    @Deprecated('Unused argument. Will be removed in 5.0.0.') // ignore: avoid-unused-parameters
        LintConfig? config,
  }) =>
      reporter(
        name: name,
        output: output,
        reportFolder: reportFolder,
      );

  LintFileReport? runPluginAnalysis(
    ResolvedUnitResult result,
    LintAnalysisConfig config,
    String rootFolder,
  ) {
    if (!isExcluded(result.path, config.globalExcludes)) {
      return _runAnalysisForFile(
        result,
        config,
        rootFolder,
        filePath: result.path,
      );
    }

    return null;
  }

  Future<Iterable<LintFileReport>> runCliAnalysis(
    Iterable<String> folders,
    String rootFolder,
    LintConfig config,
  ) async {
    final collection = createAnalysisContextCollection(folders, rootFolder);

    final analyzerResult = <LintFileReport>[];

    for (final context in collection.contexts) {
      final analysisOptions = await analysisOptionsFromContext(context) ??
          await analysisOptionsFromFilePath(rootFolder);

      final excludesRootFolder = analysisOptions.folderPath ?? rootFolder;

      final contextConfig =
          ConfigBuilder.getLintConfigFromOptions(analysisOptions).merge(config);
      final lintAnalysisConfig = ConfigBuilder.getLintAnalysisConfig(
        contextConfig,
        excludesRootFolder,
      );

      final contextFolders = folders
          .where((path) => normalize(join(rootFolder, path))
              .startsWith(context.contextRoot.root.path))
          .toList();

      final filePaths = extractDartFilesFromFolders(
        contextFolders,
        rootFolder,
        lintAnalysisConfig.globalExcludes,
      );

      final analyzedFiles =
          filePaths.intersection(context.contextRoot.analyzedFiles().toSet());

      for (final filePath in analyzedFiles) {
        final unit = await context.currentSession.getResolvedUnit(filePath);
        if (unit is ResolvedUnitResult) {
          final result = _runAnalysisForFile(
            unit,
            lintAnalysisConfig,
            rootFolder,
            filePath: filePath,
          );

          if (result != null) {
            analyzerResult.add(result);
          }
        }
      }
    }

    return analyzerResult;
  }

  LintFileReport? _runAnalysisForFile(
    ResolvedUnitResult result,
    LintAnalysisConfig config,
    String rootFolder, {
    String? filePath,
  }) {
    if (result.state == ResultState.VALID &&
        filePath != null &&
        _isSupported(result)) {
      final ignores = Suppression(result.content, result.lineInfo);
      final internalResult = InternalResolvedUnitResult(
        filePath,
        result.content,
        result.unit,
        result.lineInfo,
      );
      final relativePath = relative(filePath, from: rootFolder);

      final issues = <Issue>[];
      if (!isExcluded(filePath, config.rulesExcludes)) {
        issues.addAll(
          _checkOnCodeIssues(
            ignores,
            internalResult,
            config,
            filePath,
          ),
        );
      }

      if (!isExcluded(filePath, config.metricsExcludes)) {
        final visitor = ScopeVisitor();
        internalResult.unit.visitChildren(visitor);

        final functions = visitor.functions.where((function) {
          final declaration = function.declaration;
          if (declaration is ConstructorDeclaration &&
              declaration.body is EmptyFunctionBody) {
            return false;
          } else if (declaration is MethodDeclaration &&
              declaration.body is EmptyFunctionBody) {
            return false;
          }

          return true;
        }).toList();

        final antiPatterns = _checkOnAntiPatterns(
          ignores,
          internalResult,
          functions,
          config,
        );

        final classMetrics = _checkClassMetrics(
          visitor,
          internalResult,
          config,
        );

        final functionMetrics = _checkFunctionMetrics(
          visitor,
          internalResult,
          config,
        );

        return LintFileReport(
          path: filePath,
          relativePath: relativePath,
          classes: Map.unmodifiable(classMetrics
              .map<String, Report>((key, value) => MapEntry(key.name, value))),
          functions: Map.unmodifiable(functionMetrics.map<String, Report>(
            (key, value) => MapEntry(key.fullName, value),
          )),
          issues: issues,
          antiPatternCases: antiPatterns,
        );
      }

      return LintFileReport(
        path: filePath,
        relativePath: relativePath,
        classes: const {},
        functions: const {},
        issues: issues,
        antiPatternCases: const [],
      );
    }

    return null;
  }

  Iterable<Issue> _checkOnCodeIssues(
    Suppression ignores,
    InternalResolvedUnitResult source,
    LintAnalysisConfig config,
    String filePath,
  ) =>
      config.codeRules
          .where((rule) =>
              !ignores.isSuppressed(rule.id) &&
              !isExcluded(
                filePath,
                prepareExcludes(rule.excludes, config.excludesRootFolder),
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
    Iterable<ScopedFunctionDeclaration> functions,
    LintAnalysisConfig config,
  ) =>
      config.antiPatterns
          .where((pattern) => !ignores.isSuppressed(pattern.id))
          .expand((pattern) => pattern
              .legacyCheck(source, functions, config.metricsConfig)
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
      final metrics = <MetricValue<num>>[];

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

  Map<ScopedFunctionDeclaration, Report> _checkFunctionMetrics(
    ScopeVisitor visitor,
    InternalResolvedUnitResult source,
    LintAnalysisConfig config,
  ) {
    final functionRecords = <ScopedFunctionDeclaration, Report>{};

    for (final function in visitor.functions) {
      final metrics = <MetricValue<num>>[];

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

  bool _isSupported(AnalysisResult result) =>
      result.path.endsWith('.dart') && !result.path.endsWith('.g.dart');
}
