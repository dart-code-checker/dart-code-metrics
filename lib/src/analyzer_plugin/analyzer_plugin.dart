import 'dart:async';

import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/file_system/file_system.dart';
import 'package:analyzer/src/context/builder.dart';
import 'package:analyzer/src/context/context_root.dart';
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
import 'package:path/path.dart' as p;
import 'package:source_span/source_span.dart';

import '../metrics_analyzer_utils.dart';
import '../scope_ast_visitor.dart';

class MetricsAnalyzerPlugin extends ServerPlugin {
  Config _metricsConfig;
  Iterable<Glob> _metricsExclude;
  Iterable<BaseRule> _checkingCodeRules;

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

    final options = _readOptions(root);
    _metricsConfig = options?.metricsConfig;
    _metricsExclude = options?.metricsExcludePatterns
            ?.map((exclude) => Glob(p.join(contextRoot.root, exclude)))
            ?.toList() ??
        [];
    _checkingCodeRules =
        options?.rules != null ? getRulesById(options.rules) : [];

    final contextBuilder = ContextBuilder(resourceProvider, sdkManager, null)
      ..analysisDriverScheduler = analysisDriverScheduler
      ..byteStore = byteStore
      ..performanceLog = performanceLog
      ..fileContentOverlay = fileContentOverlay;

    final dartDriver = contextBuilder.buildDriver(root);
    Future.forEach(dartDriver.analysisContext.contextRoot.analyzedFiles(),
        dartDriver.getResult);
    dartDriver
      ..exceptions.listen((_) {
        // TODO(dmitry): process exceptions.
      })
      ..results.listen(_processResult);

    return dartDriver;
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
    } catch (e, stackTrace) {
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
    } catch (e, stackTrace) {
      channel.sendNotification(
          plugin.PluginErrorParams(false, e.toString(), stackTrace.toString())
              .toNotification());
    }
  }

  Iterable<plugin.AnalysisErrorFixes> _check(
      ResolvedUnitResult analysisResult) {
    final result = <plugin.AnalysisErrorFixes>[];

    if (isSupported(analysisResult)) {
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

          final functionRecord = FunctionRecord(
              firstLine: analysisResult.lineInfo
                  .getLocation(function
                      .declaration.firstTokenAfterCommentAndMetadata.offset)
                  .lineNumber,
              lastLine: analysisResult.lineInfo
                  .getLocation(function.declaration.endToken.end)
                  .lineNumber,
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
            final offset =
                function.declaration.firstTokenAfterCommentAndMetadata.offset;

            final startLineInfo = analysisResult.lineInfo.getLocation(offset);

            final startSourceLocation = SourceLocation(offset,
                sourceUrl: sourceUri,
                line: startLineInfo.lineNumber,
                column: startLineInfo.columnNumber);

            if (UtilitySelector.isIssueLevel(
                functionReport.cyclomaticComplexity.violationLevel)) {
              result.add(metricReportToAnalysisErrorFixes(
                  startSourceLocation,
                  function.declaration.end - offset,
                  'Function has a Cyclomatic Complexity of ${functionReport.cyclomaticComplexity.value} (exceeds ${_metricsConfig.cyclomaticComplexityWarningLevel} allowed). Consider refactoring.',
                  'cyclomatic-complexity'));
            }

            if (UtilitySelector.isIssueLevel(
                functionReport.argumentsCount.violationLevel)) {
              result.add(metricReportToAnalysisErrorFixes(
                  startSourceLocation,
                  function.declaration.end - offset,
                  'Function has ${functionReport.argumentsCount.value} number of arguments (exceeds ${_metricsConfig.numberOfArgumentsWarningLevel} allowed). Consider refactoring.',
                  'number-of-arguments'));
            }
          }
        }
      }
    }

    return result;
  }

  AnalysisOptions _readOptions(ContextRoot contextRoot) {
    if (contextRoot?.optionsFilePath?.isNotEmpty ?? false) {
      final file = resourceProvider.getFile(contextRoot.optionsFilePath);
      if (file.exists) {
        return AnalysisOptions.from(file.readAsStringSync());
      }
    }

    return null;
  }
}
