import 'dart:async';

import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/file_system/file_system.dart';
import 'package:analyzer/src/context/builder.dart';
import 'package:analyzer/src/context/context_root.dart';
import 'package:analyzer/src/dart/analysis/driver.dart';
import 'package:analyzer_plugin/plugin/plugin.dart';
import 'package:analyzer_plugin/protocol/protocol_common.dart' as plugin;
import 'package:analyzer_plugin/protocol/protocol_generated.dart' as plugin;
import 'package:dart_code_metrics/src/analyzer_plugin/checker.dart';

class MetricsAnalyzerPlugin extends ServerPlugin {
  final Checker checker = Checker();

  MetricsAnalyzerPlugin(ResourceProvider provider) : super(provider);

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
    final result = contextBuilder.buildDriver(root);
    result.results.listen(_processResult);
    return result;
  }

  @override
  List<String> get fileGlobsToAnalyze => const ['*.dart'];

  @override
  String get name => 'Dart Code Metrics';

  @override
  String get version => '1.4.0';

  @override
  String get contactInfo => 'https://github.com/wrike/dart-code-metrics/issues';

  void _processResult(ResolvedUnitResult analysisResult) {
    try {
      if (analysisResult.unit == null ||
          analysisResult.libraryElement == null) {
        channel.sendNotification(
            plugin.AnalysisErrorsParams(analysisResult.path, [])
                .toNotification());
      } else {
        final checkResult = checker.check(analysisResult.libraryElement);
        channel.sendNotification(plugin.AnalysisErrorsParams(
                analysisResult.path, checkResult.keys.toList())
            .toNotification());
      }
    } catch (e, stackTrace) {
      channel.sendNotification(
          plugin.PluginErrorParams(false, e.toString(), stackTrace.toString())
              .toNotification());
    }
  }

  @override
  void contentChanged(String path) {
    super.driverForPath(path).addFile(path);
  }

  @override
  Future<plugin.EditGetFixesResult> handleEditGetFixes(
      plugin.EditGetFixesParams parameters) async {
    try {
      final analysisResult =
          await (driverForPath(parameters.file) as AnalysisDriver)
              .getResult(parameters.file);

      final checkResult = checker.check(analysisResult.libraryElement);

      final fixes = <plugin.AnalysisErrorFixes>[];
      for (var error in checkResult.keys) {
        if (error.location.file == parameters.file &&
            checkResult[error].change.edits.single.edits.isNotEmpty) {
          fixes.add(
              plugin.AnalysisErrorFixes(error, fixes: [checkResult[error]]));
        }
      }

      return plugin.EditGetFixesResult(fixes);
    } catch (e, stackTrace) {
      channel.sendNotification(
          plugin.PluginErrorParams(false, e.toString(), stackTrace.toString())
              .toNotification());
      return plugin.EditGetFixesResult([]);
    }
  }
}
