// ignore_for_file: public_member_api_docs, long-method
import 'dart:async';

import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/file_system/file_system.dart';

// ignore: implementation_imports
import 'package:analyzer/src/analysis_options/analysis_options_provider.dart';

// ignore: implementation_imports
import 'package:analyzer/src/context/builder.dart';

// ignore: implementation_imports
import 'package:analyzer/src/context/context_root.dart';

// ignore: implementation_imports
import 'package:analyzer/src/dart/analysis/driver.dart';
import 'package:analyzer_plugin/plugin/plugin.dart';
import 'package:analyzer_plugin/protocol/protocol_generated.dart' as plugin;
import 'package:code_checker/checker.dart';
import 'package:code_checker/metrics.dart';
import 'package:source_span/source_span.dart';

import '../../suppression.dart';
import '../anti_patterns_factory.dart';
import '../config/analysis_options.dart';
import '../models/function_record.dart';
import '../models/function_report.dart' as metrics;
import '../models/internal_resolved_unit_result.dart';
import '../reporters/utility_selector.dart';
import '../rules_factory.dart';
import '../utils/metrics_analyzer_utils.dart';
import 'analyzer_plugin_config.dart';
import 'analyzer_plugin_utils.dart';

const _codeMetricsId = 'code-metrics';

const _defaultSkippedFolders = ['.dart_tool/**', 'packages/**'];

class MetricsAnalyzerPlugin extends ServerPlugin {
  final _configs = <AnalysisDriverGeneric, AnalyzerPluginConfig>{};

  var _filesFromSetPriorityFilesRequest = <String>[];

  @override
  String get contactInfo => 'https://github.com/wrike/dart-code-metrics/issues';

  @override
  List<String> get fileGlobsToAnalyze => const ['*.dart'];

  @override
  String get name => 'Dart Code Metrics';

  @override
  String get version => '1.0.0-alpha.0';

  MetricsAnalyzerPlugin(ResourceProvider provider) : super(provider);

  @override
  void contentChanged(String path) {
    super.driverForPath(path).addFile(path);
  }

  @override
  AnalysisDriverGeneric createAnalysisDriver(plugin.ContextRoot contextRoot) {
    final root = ContextRoot(
      contextRoot.root,
      contextRoot.exclude,
      pathContext: resourceProvider.pathContext,
    )..optionsFilePath = contextRoot.optionsFile;

    final contextBuilder = ContextBuilder(resourceProvider, sdkManager, null)
      ..analysisDriverScheduler = analysisDriverScheduler
      ..byteStore = byteStore
      ..performanceLog = performanceLog
      ..fileContentOverlay = fileContentOverlay;

    final dartDriver = contextBuilder.buildDriver(root);

    final options = _readOptions(dartDriver);
    _configs[dartDriver] = AnalyzerPluginConfig(
      options?.metricsConfig,
      prepareExcludes(
        [
          ..._defaultSkippedFolders,
          if (options?.excludePatterns != null) ...options.excludePatterns,
        ],
        contextRoot.root,
      ),
      prepareExcludes(options?.excludeForMetricsPatterns, contextRoot.root),
      options?.antiPatterns != null
          ? getPatternsById(options.antiPatterns)
          : [],
      options?.rules != null ? getRulesById(options.rules) : [],
    );

    runZonedGuarded(
      () {
        dartDriver.results.listen((analysisResult) {
          _processResult(dartDriver, analysisResult);
        });
      },
      (e, stackTrace) {
        channel.sendNotification(
          plugin.PluginErrorParams(false, e.toString(), stackTrace.toString())
              .toNotification(),
        );
      },
    );

    return dartDriver;
  }

  @override
  Future<plugin.AnalysisSetContextRootsResult> handleAnalysisSetContextRoots(
    plugin.AnalysisSetContextRootsParams parameters,
  ) async {
    final result = await super.handleAnalysisSetContextRoots(parameters);
    // The super-call adds files to the driver, so we need to prioritize them so they get analyzed.
    _updatePriorityFiles();

    return result;
  }

  @override
  Future<plugin.AnalysisSetPriorityFilesResult> handleAnalysisSetPriorityFiles(
    plugin.AnalysisSetPriorityFilesParams parameters,
  ) async {
    _filesFromSetPriorityFilesRequest = parameters.files;
    _updatePriorityFiles();

    return plugin.AnalysisSetPriorityFilesResult();
  }

  @override
  Future<plugin.EditGetFixesResult> handleEditGetFixes(
    plugin.EditGetFixesParams parameters,
  ) async {
    try {
      final driver = driverForPath(parameters.file) as AnalysisDriver;
      final analysisResult = await driver.getResult(parameters.file);

      final fixes = _check(driver, analysisResult)
          .where((fix) =>
              fix.error.location.file == parameters.file &&
              fix.error.location.offset <= parameters.offset &&
              parameters.offset <=
                  fix.error.location.offset + fix.error.location.length &&
              fix.fixes.isNotEmpty)
          .toList();

      return plugin.EditGetFixesResult(fixes);
    } on Exception catch (e, stackTrace) {
      channel.sendNotification(
        plugin.PluginErrorParams(false, e.toString(), stackTrace.toString())
            .toNotification(),
      );

      return plugin.EditGetFixesResult([]);
    }
  }

  void _processResult(
    AnalysisDriver driver,
    ResolvedUnitResult analysisResult,
  ) {
    try {
      if (analysisResult.unit != null &&
          analysisResult.libraryElement != null) {
        final fixes = _check(driver, analysisResult);

        channel.sendNotification(plugin.AnalysisErrorsParams(
          analysisResult.path,
          fixes.map((fix) => fix.error).toList(),
        ).toNotification());
      } else {
        channel.sendNotification(
          plugin.AnalysisErrorsParams(analysisResult.path, []).toNotification(),
        );
      }
    } on Exception catch (e, stackTrace) {
      channel.sendNotification(
        plugin.PluginErrorParams(false, e.toString(), stackTrace.toString())
            .toNotification(),
      );
    }
  }

  Iterable<plugin.AnalysisErrorFixes> _check(
    AnalysisDriver driver,
    ResolvedUnitResult analysisResult,
  ) {
    final result = <plugin.AnalysisErrorFixes>[];
    final config = _configs[driver];

    if (isSupported(analysisResult) &&
        config != null &&
        !isExcluded(analysisResult, config.globalExcludes)) {
      final ignores =
          Suppression(analysisResult.content, analysisResult.lineInfo);

      final sourceUri =
          resourceProvider.getFile(analysisResult.path)?.toUri() ??
              analysisResult.uri;

      result.addAll(_checkOnCodeIssues(
        ignores,
        analysisResult,
        sourceUri,
        _configs[driver],
      ));

      if (!isExcluded(analysisResult, config.metricsExcludes)) {
        final scopeVisitor = ScopeVisitor();
        analysisResult.unit.visitChildren(scopeVisitor);

        final functions = scopeVisitor.functions.where((function) {
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

        result.addAll(_checkOnAntiPatterns(
          ignores,
          InternalResolvedUnitResult(
            sourceUri,
            analysisResult.content,
            analysisResult.unit,
          ),
          functions,
          _configs[driver],
        ));

        if (!ignores.isSuppressed(_codeMetricsId)) {
          result.addAll(_checkMetrics(
            ignores,
            InternalResolvedUnitResult(
              sourceUri,
              analysisResult.content,
              analysisResult.unit,
            ),
            functions,
            _configs[driver],
          ));
        }
      }
    }

    return result;
  }

  Iterable<plugin.AnalysisErrorFixes> _checkOnCodeIssues(
    Suppression ignores,
    ResolvedUnitResult analysisResult,
    Uri sourceUri,
    AnalyzerPluginConfig config,
  ) =>
      config.checkingCodeRules
          .where((rule) => !ignores.isSuppressed(rule.id))
          .expand((rule) => rule
              .check(InternalResolvedUnitResult(
                sourceUri,
                analysisResult.content,
                analysisResult.unit,
              ))
              .where((issue) => !ignores.isSuppressedAt(
                    issue.ruleId,
                    issue.location.start.line,
                  ))
              .map((issue) =>
                  codeIssueToAnalysisErrorFixes(issue, analysisResult)));

  Iterable<plugin.AnalysisErrorFixes> _checkOnAntiPatterns(
    Suppression ignores,
    InternalResolvedUnitResult source,
    Iterable<ScopedFunctionDeclaration> functions,
    AnalyzerPluginConfig config,
  ) =>
      config.checkingAntiPatterns
          .where((pattern) => !ignores.isSuppressed(pattern.id))
          .expand((pattern) =>
              pattern.check(source, functions, config.metricsConfigs))
          .where((issue) =>
              !ignores.isSuppressedAt(issue.ruleId, issue.location.start.line))
          .map(designIssueToAnalysisErrorFixes);

  Iterable<plugin.AnalysisErrorFixes> _checkMetrics(
    Suppression ignores,
    InternalResolvedUnitResult source,
    Iterable<ScopedFunctionDeclaration> functions,
    AnalyzerPluginConfig config,
  ) {
    final result = <plugin.AnalysisErrorFixes>[];

    for (final function in functions) {
      final functionOffset =
          function.declaration.firstTokenAfterCommentAndMetadata.offset;

      final functionFirstLineInfo =
          source.unit.lineInfo.getLocation(functionOffset);

      if (ignores.isSuppressedAt(
        _codeMetricsId,
        functionFirstLineInfo.lineNumber,
      )) {
        continue;
      }

      final functionReport = _buildReport(function, source, config);
      if (isReportLevel(
        UtilitySelector.functionViolationLevel(functionReport),
      )) {
        final startSourceLocation = SourceLocation(
          functionOffset,
          sourceUrl: source.uri,
          line: functionFirstLineInfo.lineNumber,
          column: functionFirstLineInfo.columnNumber,
        );

        final cyclomatic = _cyclomaticComplexityMetric(
          function,
          functionReport,
          startSourceLocation,
          config,
        );
        if (cyclomatic != null) {
          result.add(cyclomatic);
        }

        final nesting = _nestingLevelMetric(
          function,
          functionReport,
          startSourceLocation,
          config,
        );
        if (nesting != null) {
          result.add(nesting);
        }
      }
    }

    return result;
  }

  metrics.FunctionReport _buildReport(
    ScopedFunctionDeclaration function,
    InternalResolvedUnitResult source,
    AnalyzerPluginConfig config,
  ) {
    final controlFlowAstVisitor = CyclomaticComplexityFlowVisitor(source);

    function.declaration.visitChildren(controlFlowAstVisitor);

    final cyclomaticLines = controlFlowAstVisitor.complexityElements
        .map((element) => element.start.line)
        .toSet();

    return UtilitySelector.functionReport(
      FunctionRecord(
        location: nodeLocation(
          node: function.declaration,
          source: source,
        ),
        metrics: const [],
        argumentsCount: getArgumentsCount(function),
        cyclomaticComplexityLines: Map.fromEntries(cyclomaticLines.map(
          (lineIndex) => MapEntry(
            lineIndex,
            controlFlowAstVisitor.complexityElements
                .where((element) => element.start.line == lineIndex)
                .length,
          ),
        )),
        linesWithCode: List.unmodifiable(<int>[]),
        operators: Map.unmodifiable(<String, int>{}),
        operands: Map.unmodifiable(<String, int>{}),
      ),
      config.metricsConfigs,
    );
  }

  plugin.AnalysisErrorFixes _cyclomaticComplexityMetric(
    ScopedFunctionDeclaration function,
    metrics.FunctionReport functionReport,
    SourceLocation startSourceLocation,
    AnalyzerPluginConfig config,
  ) =>
      isReportLevel(functionReport.cyclomaticComplexity.level)
          ? metricReportToAnalysisErrorFixes(
              startSourceLocation,
              function.declaration.end - startSourceLocation.offset,
              '${function.type} has a Cyclomatic Complexity of ${functionReport.cyclomaticComplexity.value} (exceeds ${config.metricsConfigs.cyclomaticComplexityWarningLevel} allowed). Consider refactoring.',
              _codeMetricsId,
            )
          : null;

  plugin.AnalysisErrorFixes _nestingLevelMetric(
    ScopedFunctionDeclaration function,
    metrics.FunctionReport functionReport,
    SourceLocation startSourceLocation,
    AnalyzerPluginConfig config,
  ) =>
      isReportLevel(functionReport.maximumNestingLevel.level)
          ? metricReportToAnalysisErrorFixes(
              startSourceLocation,
              function.declaration.end - startSourceLocation.offset,
              '${function.type} has a Nesting Level of ${functionReport.maximumNestingLevel.value} (exceeds ${config.metricsConfigs.maximumNestingWarningLevel} allowed). Consider refactoring.',
              _codeMetricsId,
            )
          : null;

  AnalysisOptions _readOptions(AnalysisDriver driver) {
    if (driver?.contextRoot?.optionsFilePath?.isNotEmpty ?? false) {
      final file = resourceProvider.getFile(driver.contextRoot.optionsFilePath);
      if (file.exists) {
        return AnalysisOptions.fromMap(yamlMapToDartMap(
          AnalysisOptionsProvider(driver.sourceFactory)
              .getOptionsFromFile(file),
        ));
      }
    }

    return null;
  }

  /// AnalysisDriver doesn't fully resolve files that are added via `addFile`; they need to be either explicitly requested
  /// via `getResult`/etc, or added to `priorityFiles`.
  ///
  /// This method updates `priorityFiles` on the driver to include:
  ///
  /// - Any files prioritized by the analysis server via [handleAnalysisSetPriorityFiles]
  /// - All other files the driver has been told to analyze via addFile (in [ServerPlugin.handleAnalysisSetContextRoots])
  ///
  /// As a result, [_processResult] will get called with resolved units, and thus all of our diagnostics
  /// will get run on all files in the repo instead of only the currently open/edited ones!
  void _updatePriorityFiles() {
    final filesToFullyResolve = {
      // Ensure these go first, since they're actually considered priority; ...
      ..._filesFromSetPriorityFilesRequest,

      // ... all other files need to be analyzed, but don't trump priority
      for (final driver2 in driverMap.values)
        ...(driver2 as AnalysisDriver).addedFiles,
    };

    // From ServerPlugin.handleAnalysisSetPriorityFiles
    final filesByDriver = <AnalysisDriverGeneric, List<String>>{};
    for (final file in filesToFullyResolve) {
      final contextRoot = contextRootContaining(file);
      if (contextRoot != null) {
        // TODO(dkrutskikh): Which driver should we use if there is no context root?
        final driver = driverMap[contextRoot];
        filesByDriver.putIfAbsent(driver, () => <String>[]).add(file);
      }
    }
    filesByDriver.forEach((driver, files) {
      driver.priorityFiles = files;
    });
  }
}
