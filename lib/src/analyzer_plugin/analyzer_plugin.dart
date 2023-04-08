// ignore_for_file: public_member_api_docs
import 'dart:async';

import 'package:analyzer/dart/analysis/analysis_context.dart';
import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer_plugin/plugin/plugin.dart';
import 'package:analyzer_plugin/protocol/protocol_generated.dart' as plugin;
import 'package:http/http.dart';
import 'package:uuid/uuid.dart';

import '../analyzers/lint_analyzer/lint_analysis_config.dart';
import '../analyzers/lint_analyzer/lint_analysis_options_validator.dart';
import '../analyzers/lint_analyzer/lint_analyzer.dart';
import '../analyzers/lint_analyzer/metrics/metrics_list/number_of_parameters_metric.dart';
import '../analyzers/lint_analyzer/metrics/metrics_list/source_lines_of_code/source_lines_of_code_metric.dart';
import '../config_builder/config_builder.dart';
import '../config_builder/models/analysis_options.dart';
import '../version.dart';
import 'analyzer_plugin_utils.dart';

class AnalyzerPlugin extends ServerPlugin {
  static const _analyzer = LintAnalyzer();

  final _configs = <String, LintAnalysisConfig>{};

  AnalysisContextCollection? _contextCollection;

  @override
  String get contactInfo =>
      'https://github.com/dart-code-checker/dart-code-metrics/issues';

  @override
  List<String> get fileGlobsToAnalyze => const ['*.dart', '*.yaml'];

  @override
  String get name => 'DCM $packageVersion';

  @override
  String get version => '1.0.0-alpha.0';

  AnalyzerPlugin({
    required super.resourceProvider,
  }) {
    final location =
        resourceProvider.getStateLocation('.dart-code-metrics-uuid');
    if (location == null) {
      return;
    }

    var uuid = '';

    final file = location.getChildAssumingFile('uuid');
    if (!file.exists) {
      uuid = const Uuid().v4();
      file
        ..createSource(file.toUri())
        ..writeAsStringSync(uuid);
    } else {
      uuid = file.readAsStringSync();
    }

    final uri = Uri.parse('https://dcm.dev/api/analytics/usage');

    post(uri, body: {'uuid': uuid, 'version': packageVersion}).ignore();
  }

  @override
  Future<void> afterNewContextCollection({
    required AnalysisContextCollection contextCollection,
  }) {
    _contextCollection = contextCollection;

    contextCollection.contexts.forEach(_createConfig);

    return super
        .afterNewContextCollection(contextCollection: contextCollection);
  }

  @override
  Future<void> analyzeFile({
    required AnalysisContext analysisContext,
    required String path,
  }) async {
    final isAnalyzed = analysisContext.contextRoot.isAnalyzed(path);
    if (!isAnalyzed) {
      return;
    }

    final rootPath = analysisContext.contextRoot.root.path;
    if (path.endsWith('analysis_options.yaml')) {
      final config = _configs[rootPath];
      if (config != null) {
        _validateAnalysisOptions(config, rootPath);
      }
    }

    try {
      final resolvedUnit =
          await analysisContext.currentSession.getResolvedUnit(path);

      if (resolvedUnit is ResolvedUnitResult) {
        final analysisErrors =
            _getErrorsForResolvedUnit(resolvedUnit, rootPath);

        channel.sendNotification(
          plugin.AnalysisErrorsParams(
            path,
            analysisErrors.map((analysisError) => analysisError.error).toList(),
          ).toNotification(),
        );
      } else {
        channel.sendNotification(
          plugin.AnalysisErrorsParams(path, []).toNotification(),
        );
      }
    } on Exception catch (e, stackTrace) {
      channel.sendNotification(
        plugin.PluginErrorParams(false, e.toString(), stackTrace.toString())
            .toNotification(),
      );
    }
  }

  @override
  Future<plugin.EditGetFixesResult> handleEditGetFixes(
    plugin.EditGetFixesParams parameters,
  ) async {
    try {
      final path = parameters.file;
      final analysisContext = _contextCollection?.contextFor(path);
      final resolvedUnit =
          await analysisContext?.currentSession.getResolvedUnit(path);

      if (analysisContext != null && resolvedUnit is ResolvedUnitResult) {
        final analysisErrors = _getErrorsForResolvedUnit(
          resolvedUnit,
          analysisContext.contextRoot.root.path,
        ).where((analysisError) {
          final location = analysisError.error.location;

          return location.file == parameters.file &&
              location.offset <= parameters.offset &&
              parameters.offset <= location.offset + location.length &&
              analysisError.fixes.isNotEmpty;
        }).toList();

        return plugin.EditGetFixesResult(analysisErrors);
      }
    } on Exception catch (e, stackTrace) {
      channel.sendNotification(
        plugin.PluginErrorParams(false, e.toString(), stackTrace.toString())
            .toNotification(),
      );
    }

    return plugin.EditGetFixesResult([]);
  }

  Iterable<plugin.AnalysisErrorFixes> _getErrorsForResolvedUnit(
    ResolvedUnitResult analysisResult,
    String rootPath,
  ) {
    final result = <plugin.AnalysisErrorFixes>[];
    final config = _configs[rootPath];

    if (config != null) {
      final report =
          _analyzer.runPluginAnalysis(analysisResult, config, rootPath);

      if (report != null) {
        result.addAll([
          ...report.issues,
          ...report.antiPatternCases,
        ].map((issue) => codeIssueToAnalysisErrorFixes(issue, analysisResult)));
      }

      // Temporary disable deprecation check
      //
      // if (analysisResult.path ==
      //     driver.analysisContext?.contextRoot.optionsFile?.path) {
      //   final deprecations = checkConfigDeprecatedOptions(
      //     config,
      //     deprecatedOptions,
      //     analysisResult.path ?? '',
      //   );
      //
      //   result.addAll(deprecations);
      // }
    }

    return result;
  }

  void _createConfig(AnalysisContext analysisContext) {
    final rootPath = analysisContext.contextRoot.root.path;
    final file = analysisContext.contextRoot.optionsFile;

    if (file != null && file.exists) {
      final analysisOptions = analysisOptionsFromContext(analysisContext) ??
          analysisOptionsFromFilePath(file.parent.path, analysisContext);
      final config = ConfigBuilder.getLintConfigFromOptions(analysisOptions);

      final lintConfig = ConfigBuilder.getLintAnalysisConfig(
        config,
        analysisOptions.folderPath ?? rootPath,
        classMetrics: const [],
        functionMetrics: [
          NumberOfParametersMetric(config: config.metrics),
          SourceLinesOfCodeMetric(config: config.metrics),
        ],
      );

      _configs[rootPath] = lintConfig;

      _validateAnalysisOptions(lintConfig, rootPath);
    }
  }

  void _validateAnalysisOptions(LintAnalysisConfig config, String rootPath) {
    if (config.analysisOptionsPath == null) {
      return;
    }

    final result = <plugin.AnalysisErrorFixes>[];

    final report =
        LintAnalysisOptionsValidator.validateOptions(config, rootPath);
    if (report != null) {
      result.addAll(report.issues.map(
        (issue) => codeIssueToAnalysisErrorFixes(issue, null),
      ));
    }

    channel.sendNotification(
      plugin.AnalysisErrorsParams(
        config.analysisOptionsPath!,
        result.map((analysisError) => analysisError.error).toList(),
      ).toNotification(),
    );
  }
}
