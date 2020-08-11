import 'dart:async';

import 'package:analyzer/dart/analysis/results.dart';
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
import 'package:analyzer_plugin/protocol/protocol_common.dart' as plugin;
import 'package:analyzer_plugin/protocol/protocol_generated.dart' as plugin;
import 'package:dart_code_metrics/src/analysis_options.dart';
import 'package:dart_code_metrics/src/analyzer_plugin/analyzer_plugin_utils.dart';
import 'package:dart_code_metrics/src/ignore_info.dart';
import 'package:dart_code_metrics/src/metrics/cyclomatic_complexity/control_flow_ast_visitor.dart';
import 'package:dart_code_metrics/src/metrics/cyclomatic_complexity/cyclomatic_config.dart';
import 'package:dart_code_metrics/src/models/config.dart';
import 'package:dart_code_metrics/src/models/function_record.dart';
import 'package:dart_code_metrics/src/reporters/utility_selector.dart';
import 'package:dart_code_metrics/src/rules/base_rule.dart';
import 'package:dart_code_metrics/src/rules_factory.dart';
import 'package:glob/glob.dart';
import 'package:source_span/source_span.dart';

import '../metrics_analyzer_utils.dart';
import '../scope_ast_visitor.dart';
import '../utils/yaml_utls.dart';

class MetricsAnalyzerPlugin extends ServerPlugin {
  Config _metricsConfig;
  Iterable<Glob> _globalExclude;
  Iterable<Glob> _metricsExclude;
  Iterable<BaseRule> _checkingCodeRules;
  var _filesFromSetPriorityFilesRequest = <String>[];

  @override
  String get contactInfo => 'https://github.com/wrike/dart-code-metrics/issues';

  @override
  List<String> get fileGlobsToAnalyze => const ['*.dart'];

  @override
  String get name => 'Dart Code Metrics';

  @override
  String get version => '1.8.1';

  MetricsAnalyzerPlugin(ResourceProvider provider)
      : _checkingCodeRules = [],
        super(provider);

  @override
  void contentChanged(String path) {
    super.driverForPath(path).addFile(path);
  }

  @override
  AnalysisDriverGeneric createAnalysisDriver(plugin.ContextRoot contextRoot) {
    final root = ContextRoot(contextRoot.root, contextRoot.exclude,
        pathContext: resourceProvider.pathContext)
      ..optionsFilePath = contextRoot.optionsFile;

    final contextBuilder = ContextBuilder(resourceProvider, sdkManager, null)
      ..analysisDriverScheduler = analysisDriverScheduler
      ..byteStore = byteStore
      ..performanceLog = performanceLog
      ..fileContentOverlay = fileContentOverlay;

    final dartDriver = contextBuilder.buildDriver(root);

    final options = _readOptions(dartDriver);
    _metricsConfig = options?.metricsConfig;
    _globalExclude =
        prepareExcludes(options?.excludePatterns, contextRoot.root);
    _metricsExclude =
        prepareExcludes(options?.metricsExcludePatterns, contextRoot.root);
    _checkingCodeRules =
        options?.rules != null ? getRulesById(options.rules) : [];

    // TODO(dmitrykrutskih): Once we are ready to bump the SDK lower bound to 2.8.x, we should swap this out for `runZoneGuarded`.
    runZoned(() {
      dartDriver.results.listen(_processResult);
      // ignore: avoid_types_on_closure_parameters
    }, onError: (Object e, StackTrace stackTrace) {
      channel.sendNotification(
          plugin.PluginErrorParams(false, e.toString(), stackTrace.toString())
              .toNotification());
    });

    return dartDriver;
  }

  @override
  Future<plugin.AnalysisSetContextRootsResult> handleAnalysisSetContextRoots(
      plugin.AnalysisSetContextRootsParams parameters) async {
    final result = await super.handleAnalysisSetContextRoots(parameters);
    // The super-call adds files to the driver, so we need to prioritize them so they get analyzed.
    _updatePriorityFiles();

    return result;
  }

  @override
  Future<plugin.AnalysisSetPriorityFilesResult> handleAnalysisSetPriorityFiles(
      plugin.AnalysisSetPriorityFilesParams parameters) async {
    _filesFromSetPriorityFilesRequest = parameters.files;
    _updatePriorityFiles();

    return plugin.AnalysisSetPriorityFilesResult();
  }

  @override
  Future<plugin.EditGetFixesResult> handleEditGetFixes(
      plugin.EditGetFixesParams parameters) async {
    try {
      final analysisResult =
          await (driverForPath(parameters.file) as AnalysisDriver)
              .getResult(parameters.file);

      final fixes = _check(analysisResult)
          .where((fix) =>
              fix.error.location.file == parameters.file &&
              fix.fixes.isNotEmpty)
          .toList();

      return plugin.EditGetFixesResult(fixes);
    } on Exception catch (e, stackTrace) {
      channel.sendNotification(
          plugin.PluginErrorParams(false, e.toString(), stackTrace.toString())
              .toNotification());

      return plugin.EditGetFixesResult([]);
    }
  }

  void _processResult(ResolvedUnitResult analysisResult) {
    try {
      if (analysisResult.unit != null &&
          analysisResult.libraryElement != null) {
        final fixes = _check(analysisResult);

        channel.sendNotification(plugin.AnalysisErrorsParams(
                analysisResult.path, fixes.map((fix) => fix.error).toList())
            .toNotification());
      } else {
        channel.sendNotification(
            plugin.AnalysisErrorsParams(analysisResult.path, [])
                .toNotification());
      }
    } on Exception catch (e, stackTrace) {
      channel.sendNotification(
          plugin.PluginErrorParams(false, e.toString(), stackTrace.toString())
              .toNotification());
    }
  }

  Iterable<plugin.AnalysisErrorFixes> _check(
      ResolvedUnitResult analysisResult) {
    final result = <plugin.AnalysisErrorFixes>[];

    if (isSupported(analysisResult) &&
        !isExcluded(analysisResult, _globalExclude)) {
      final ignores = IgnoreInfo.calculateIgnores(
          analysisResult.content, analysisResult.lineInfo);

      final sourceUri =
          resourceProvider.getFile(analysisResult.path)?.toUri() ??
              analysisResult.uri;

      result.addAll(_checkingCodeRules
          .where((rule) => !ignores.ignoreRule(rule.id))
          .expand((rule) => rule
              .check(analysisResult.unit, sourceUri, analysisResult.content)
              .where((issue) =>
                  !ignores.ignoredAt(issue.ruleId, issue.sourceSpan.start.line))
              .map((issue) =>
                  codeIssueToAnalysisErrorFixes(issue, analysisResult))));

      if (_metricsConfig != null &&
          !isExcluded(analysisResult, _metricsExclude)) {
        final scopeVisitor = ScopeAstVisitor();
        analysisResult.unit.visitChildren(scopeVisitor);

        for (final function in scopeVisitor.functions) {
          final controlFlowAstVisitor = ControlFlowAstVisitor(
              defaultCyclomaticConfig, analysisResult.lineInfo);

          function.declaration.visitChildren(controlFlowAstVisitor);

          final functionOffset =
              function.declaration.firstTokenAfterCommentAndMetadata.offset;

          final functionFirstLineInfo =
              analysisResult.lineInfo.getLocation(functionOffset);
          final functionLastLineInfo = analysisResult.lineInfo
              .getLocation(function.declaration.endToken.end);

          final functionRecord = FunctionRecord(
              firstLine: functionFirstLineInfo.lineNumber,
              lastLine: functionLastLineInfo.lineNumber,
              argumentsCount: getArgumentsCount(function),
              cyclomaticComplexityLines:
                  Map.unmodifiable(controlFlowAstVisitor.complexityLines),
              linesWithCode: List.unmodifiable(<int>[]),
              operators: Map.unmodifiable(<String, int>{}),
              operands: Map.unmodifiable(<String, int>{}));

          final functionReport =
              UtilitySelector.functionReport(functionRecord, _metricsConfig);

          if (UtilitySelector.isIssueLevel(
              UtilitySelector.functionViolationLevel(functionReport))) {
            final startSourceLocation = SourceLocation(functionOffset,
                sourceUrl: sourceUri,
                line: functionFirstLineInfo.lineNumber,
                column: functionFirstLineInfo.columnNumber);

            result.addAll([
              if (UtilitySelector.isIssueLevel(
                  functionReport.cyclomaticComplexity.violationLevel))
                metricReportToAnalysisErrorFixes(
                    startSourceLocation,
                    function.declaration.end - functionOffset,
                    'Function has a Cyclomatic Complexity of ${functionReport.cyclomaticComplexity.value} (exceeds ${_metricsConfig.cyclomaticComplexityWarningLevel} allowed). Consider refactoring.',
                    'cyclomatic-complexity'),
              if (UtilitySelector.isIssueLevel(
                  functionReport.argumentsCount.violationLevel))
                metricReportToAnalysisErrorFixes(
                    startSourceLocation,
                    function.declaration.end - functionOffset,
                    'Function has ${functionReport.argumentsCount.value} number of arguments (exceeds ${_metricsConfig.numberOfArgumentsWarningLevel} allowed). Consider refactoring.',
                    'number-of-arguments'),
            ]);
          }
        }
      }
    }

    return result;
  }

  AnalysisOptions _readOptions(AnalysisDriver driver) {
    if (driver?.contextRoot?.optionsFilePath?.isNotEmpty ?? false) {
      final file = resourceProvider.getFile(driver.contextRoot.optionsFilePath);
      if (file.exists) {
        return AnalysisOptions.fromMap(yamlMapToDartMap(
            AnalysisOptionsProvider(driver.sourceFactory)
                .getOptionsFromFile(file)));
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
        // TODO(dmitrykrutskih): Which driver should we use if there is no context root?
        final driver = driverMap[contextRoot];
        filesByDriver.putIfAbsent(driver, () => <String>[]).add(file);
      }
    }
    filesByDriver.forEach((driver, files) {
      driver.priorityFiles = files;
    });
  }
}
