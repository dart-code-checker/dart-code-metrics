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

import '../scope_ast_visitor.dart';

class MetricsAnalyzerPlugin extends ServerPlugin {
  Config _metricsConfig;
  Iterable<BaseRule> _checkingCodeRules;

  MetricsAnalyzerPlugin(ResourceProvider provider)
      : _checkingCodeRules = [],
        super(provider);

  @override
  String get contactInfo => 'https://github.com/wrike/dart-code-metrics/issues';

  @override
  List<String> get fileGlobsToAnalyze => const ['*.dart'];

  @override
  String get name => 'Dart Code Metrics';

  @override
  String get version => '1.5.0';

  @override
  void contentChanged(String path) {
    super.driverForPath(path).addFile(path);
  }

  @override
  AnalysisDriverGeneric createAnalysisDriver(plugin.ContextRoot contextRoot) {
    final root = ContextRoot(contextRoot.root, contextRoot.exclude,
        pathContext: resourceProvider.pathContext)
      ..optionsFilePath = contextRoot.optionsFile;

    final config = _readOptions(root.optionsFilePath);
    _metricsConfig = config.metricsConfig;
    _checkingCodeRules = getRulesById(config?.rulesNames ?? []);

    final contextBuilder = ContextBuilder(resourceProvider, sdkManager, null)
      ..analysisDriverScheduler = analysisDriverScheduler
      ..byteStore = byteStore
      ..performanceLog = performanceLog
      ..fileContentOverlay = fileContentOverlay;

    final dartDriver = contextBuilder.buildDriver(root);
    dartDriver
      ..analysisContext
          .contextRoot
          .analyzedFiles()
          .forEach(dartDriver.getResult)
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

      result.addAll(_checkingCodeRules
          .where((rule) => !ignores.ignoreRule(rule.id))
          .expand((rule) => rule
              .check(
                  analysisResult.unit,
                  resourceProvider.getFile(analysisResult.path)?.toUri() ??
                      analysisResult.uri,
                  analysisResult.content)
              .where((issue) =>
                  !ignores.ignoredAt(issue.ruleId, issue.sourceSpan.start.line))
              .map((issue) =>
                  codeIssueToAnalysisErrorFixes(issue, analysisResult))));

      if (_metricsConfig != null) {
        final scopeVisitor = ScopeAstVisitor();
        analysisResult.unit.visitChildren(scopeVisitor);
        for (final declaration in scopeVisitor.declarations) {
          final controlFlowAstVisitor = ControlFlowAstVisitor(
              defaultCyclomaticConfig, analysisResult.unit.lineInfo);

          declaration.declaration.visitChildren(controlFlowAstVisitor);

          final functionRecord = FunctionRecord(
              firstLine: analysisResult.unit.lineInfo
                  .getLocation(declaration
                      .declaration.firstTokenAfterCommentAndMetadata.offset)
                  .lineNumber,
              lastLine: analysisResult.unit.lineInfo
                  .getLocation(declaration.declaration.endToken.end)
                  .lineNumber,
              argumentsCount: 0,
              cyclomaticComplexityLines:
                  Map.unmodifiable(controlFlowAstVisitor.complexityLines),
              linesWithCode: List.unmodifiable(<int>[]),
              operators: Map.unmodifiable(<String, int>{}),
              operands: Map.unmodifiable(<String, int>{}));

          final functionReport =
              UtilitySelector.functionReport(functionRecord, _metricsConfig);

          if (UtilitySelector.isIssueLevel(
              functionReport.cyclomaticComplexity.violationLevel)) {
            result.add(plugin.AnalysisErrorFixes(plugin.AnalysisError(
                plugin.AnalysisErrorSeverity.INFO,
                plugin.AnalysisErrorType.LINT,
                plugin.Location(
                    (resourceProvider.getFile(analysisResult.path)?.toUri() ??
                            analysisResult.uri)
                        .path,
                    declaration
                        .declaration.firstTokenAfterCommentAndMetadata.offset,
                    declaration.declaration.end -
                        declaration.declaration
                            .firstTokenAfterCommentAndMetadata.offset,
                    analysisResult.unit.lineInfo
                        .getLocation(declaration.declaration
                            .firstTokenAfterCommentAndMetadata.offset)
                        .lineNumber,
                    analysisResult.unit.lineInfo
                        .getLocation(
                            declaration.declaration.firstTokenAfterCommentAndMetadata.offset)
                        .columnNumber),
                'Function has a Cyclomatic Complexity of ${functionReport.cyclomaticComplexity.value} (exceeds ${_metricsConfig.cyclomaticComplexityWarningLevel} allowed). Consider refactoring.',
                'cyclomatic-complexity')));
          }
        }
      }
    }

    return result;
  }

  AnalysisOptions _readOptions(String optionsFilePath) {
    if (optionsFilePath != null && optionsFilePath.isNotEmpty) {
      final file = resourceProvider.getFile(optionsFilePath);
      if (file.exists) {
        return AnalysisOptions.from(file.readAsStringSync());
      }
    }

    return null;
  }
}
