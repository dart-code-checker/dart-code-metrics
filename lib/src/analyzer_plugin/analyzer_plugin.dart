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
// ignore: implementation_imports
import 'package:analyzer/src/dart/analysis/file_state.dart';
import 'package:analyzer_plugin/plugin/plugin.dart';
import 'package:analyzer_plugin/protocol/protocol_generated.dart' as plugin;
import 'package:source_span/source_span.dart';

import '../analyzers/lint_analyzer/anti_patterns/patterns_factory.dart';
import '../analyzers/lint_analyzer/metrics/metric_utils.dart';
import '../analyzers/lint_analyzer/metrics/metrics_list/cyclomatic_complexity/cyclomatic_complexity_metric.dart';
import '../analyzers/lint_analyzer/metrics/metrics_list/number_of_parameters_metric.dart';
import '../analyzers/lint_analyzer/reporters/models/function_report.dart';
import '../analyzers/lint_analyzer/reporters/utility_selector.dart';
import '../analyzers/lint_analyzer/rules/rules_factory.dart';
import '../analyzers/lint_analyzer/scope_visitor.dart';
import '../analyzers/models/internal_resolved_unit_result.dart';
import '../analyzers/models/report.dart';
import '../analyzers/models/scoped_function_declaration.dart';
import '../analyzers/models/suppression.dart';
import '../config_builder/models/analysis_options.dart';
import '../config_builder/models/config.dart';
import '../config_builder/models/deprecated_option.dart';
import '../utils/node_utils.dart';
import '../utils/yaml_utils.dart';
import 'analyzer_plugin_config.dart';
import 'analyzer_plugin_utils.dart';
import 'plugin_utils.dart';

const _codeMetricsId = 'code-metrics';

const _defaultSkippedFolders = ['.dart_tool/**', 'packages/**'];

class MetricsAnalyzerPlugin extends ServerPlugin {
  final _configs = <AnalysisDriverGeneric, AnalyzerPluginConfig>{};

  var _filesFromSetPriorityFilesRequest = <String>[];

  @override
  String get contactInfo =>
      'https://github.com/dart-code-checker/dart-code-metrics/issues';

  @override
  List<String> get fileGlobsToAnalyze => const ['*.dart'];

  @override
  String get name => 'Dart Code Metrics';

  @override
  String get version => '1.0.0-alpha.0';

  MetricsAnalyzerPlugin(ResourceProvider provider) : super(provider);

  @override
  void contentChanged(String path) {
    super.driverForPath(path)?.addFile(path);
  }

  @override
  AnalysisDriverGeneric createAnalysisDriver(plugin.ContextRoot contextRoot) {
    final rootPath = contextRoot.root;
    final root = ContextRoot(
      rootPath,
      contextRoot.exclude,
      pathContext: resourceProvider.pathContext,
    )..optionsFilePath = contextRoot.optionsFile;

    final contextBuilder = ContextBuilder(resourceProvider, sdkManager, null)
      ..analysisDriverScheduler = analysisDriverScheduler
      ..byteStore = byteStore
      ..performanceLog = performanceLog
      ..fileContentOverlay = FileContentOverlay();

    final workspace = ContextBuilder.createWorkspace(
      resourceProvider: resourceProvider,
      options: ContextBuilderOptions(),
      rootPath: rootPath,
    );

    final dartDriver = contextBuilder.buildDriver(root, workspace);

    final options = _readOptions(dartDriver);
    if (options == null) {
      return dartDriver;
    }

    _configs[dartDriver] = AnalyzerPluginConfig(
      prepareExcludes(
        [
          ..._defaultSkippedFolders,
          ...options.excludePatterns,
        ],
        rootPath,
      ),
      getRulesById(options.rules),
      [
        CyclomaticComplexityMetric(config: options.metrics),
        NumberOfParametersMetric(config: options.metrics),
      ],
      prepareExcludes(options.excludeForMetricsPatterns, rootPath),
      getPatternsById(options.antiPatterns),
      options.metrics,
    );

    // Temporary disable deprecation check
    //
    // final deprecations = checkConfigDeprecatedOptions(
    //   _configs[dartDriver]!,
    //   deprecatedOptions,
    //   contextRoot.optionsFile!,
    // );
    // if (deprecations.isNotEmpty) {
    //   channel.sendNotification(plugin.AnalysisErrorsParams(
    //     contextRoot.optionsFile!,
    //     deprecations.map((deprecation) => deprecation.error).toList(),
    //   ).toNotification());
    // }

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
      // ignore: deprecated_member_use
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
      if (analysisResult.unit != null) {
        final fixes = _check(driver, analysisResult);

        channel.sendNotification(plugin.AnalysisErrorsParams(
          analysisResult.path!,
          fixes.map((fix) => fix.error).toList(),
        ).toNotification());
      } else {
        channel.sendNotification(
          plugin.AnalysisErrorsParams(analysisResult.path!, [])
              .toNotification(),
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
    final unit = analysisResult.unit;
    final content = analysisResult.content;

    if (unit != null &&
        content != null &&
        analysisResult.state == ResultState.VALID &&
        isSupported(analysisResult) &&
        config != null &&
        !isExcluded(analysisResult, config.globalExcludes)) {
      final ignores = Suppression(content, analysisResult.lineInfo);

      final sourceUri = resourceProvider.getFile(analysisResult.path!).toUri();
      // ignore: deprecated_member_use
      final root = driver.contextRoot?.root;

      result.addAll(
        _checkOnCodeIssues(ignores, analysisResult, sourceUri, config, root),
      );

      if (!isExcluded(analysisResult, config.metricsExcludes)) {
        final scopeVisitor = ScopeVisitor();
        unit.visitChildren(scopeVisitor);

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
            content,
            unit,
            analysisResult.lineInfo,
          ),
          functions,
          config,
        ));

        if (!ignores.isSuppressed(_codeMetricsId)) {
          result.addAll(_checkMetrics(
            ignores,
            InternalResolvedUnitResult(
              sourceUri,
              content,
              unit,
              analysisResult.lineInfo,
            ),
            functions,
            config,
          ));
        }
      }
    } else if (config != null &&
        // ignore: deprecated_member_use
        analysisResult.path == driver.contextRoot?.optionsFilePath) {
      final deprecations = checkConfigDeprecatedOptions(
        config,
        deprecatedOptions,
        analysisResult.path ?? '',
      );

      result.addAll(deprecations);
    }

    return result;
  }

  Iterable<plugin.AnalysisErrorFixes> _checkOnCodeIssues(
    Suppression ignores,
    ResolvedUnitResult analysisResult,
    Uri sourceUri,
    AnalyzerPluginConfig config,
    String? root,
  ) {
    final unit = analysisResult.unit;
    final content = analysisResult.content;

    if (unit == null ||
        content == null ||
        analysisResult.state != ResultState.VALID) {
      return [];
    }

    return config.codeRules
        .where((rule) =>
            !ignores.isSuppressed(rule.id) &&
            (root == null ||
                !isExcluded(
                  analysisResult,
                  prepareExcludes(rule.excludes, root),
                )))
        .expand(
          (rule) => rule
              .check(InternalResolvedUnitResult(
                sourceUri,
                content,
                unit,
                analysisResult.lineInfo,
              ))
              .where((issue) => !ignores.isSuppressedAt(
                    issue.ruleId,
                    issue.location.start.line,
                  ))
              .map((issue) =>
                  codeIssueToAnalysisErrorFixes(issue, analysisResult)),
        );
  }

  Iterable<plugin.AnalysisErrorFixes> _checkOnAntiPatterns(
    Suppression ignores,
    InternalResolvedUnitResult source,
    Iterable<ScopedFunctionDeclaration> functions,
    AnalyzerPluginConfig config,
  ) =>
      config.antiPatterns
          .where((pattern) => !ignores.isSuppressed(pattern.id))
          .expand((pattern) =>
              pattern.legacyCheck(source, functions, config.metricsConfig))
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

      final functionFirstLineInfo = source.lineInfo.getLocation(functionOffset);

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
          sourceUrl: source.sourceUri,
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

  FunctionReport _buildReport(
    ScopedFunctionDeclaration function,
    InternalResolvedUnitResult source,
    AnalyzerPluginConfig config,
  ) =>
      UtilitySelector.functionReport(
        Report(
          location: nodeLocation(
            node: function.declaration,
            source: source,
          ),
          metrics: config.methodsMetrics.map(
            (metric) => metric.compute(
              function.declaration,
              [
                if (function.enclosingDeclaration != null)
                  function.enclosingDeclaration!,
              ],
              [function],
              source,
            ),
          ),
        ),
      );

  plugin.AnalysisErrorFixes? _cyclomaticComplexityMetric(
    ScopedFunctionDeclaration function,
    FunctionReport functionReport,
    SourceLocation startSourceLocation,
    AnalyzerPluginConfig config,
  ) =>
      isReportLevel(functionReport.cyclomaticComplexity.level)
          ? metricReportToAnalysisErrorFixes(
              startSourceLocation,
              function.declaration.end - startSourceLocation.offset,
              functionReport.cyclomaticComplexity.comment,
              _codeMetricsId,
            )
          : null;

  plugin.AnalysisErrorFixes? _nestingLevelMetric(
    ScopedFunctionDeclaration function,
    FunctionReport functionReport,
    SourceLocation startSourceLocation,
    AnalyzerPluginConfig config,
  ) =>
      isReportLevel(functionReport.maximumNestingLevel.level)
          ? metricReportToAnalysisErrorFixes(
              startSourceLocation,
              function.declaration.end - startSourceLocation.offset,
              functionReport.maximumNestingLevel.comment,
              _codeMetricsId,
            )
          : null;

  Config? _readOptions(AnalysisDriver driver) {
    // ignore: deprecated_member_use
    final optionsPath = driver.contextRoot?.optionsFilePath;
    if (optionsPath != null && optionsPath.isNotEmpty) {
      final file = resourceProvider.getFile(optionsPath);
      if (file.exists) {
        return Config.fromAnalysisOptions(
          AnalysisOptions(yamlMapToDartMap(
            AnalysisOptionsProvider(driver.sourceFactory)
                .getOptionsFromFile(file),
          )),
        );
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
        final driver = driverMap[contextRoot]!;
        filesByDriver.putIfAbsent(driver, () => <String>[]).add(file);
      }
    }
    filesByDriver.forEach((driver, files) {
      driver.priorityFiles = files;
    });
  }
}
