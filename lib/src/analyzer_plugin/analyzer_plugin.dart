// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'dart:io' as io;

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/file_system/file_system.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
// ignore: implementation_imports
import 'package:analyzer/src/analysis_options/analysis_options_provider.dart';
// ignore: implementation_imports
import 'package:analyzer/src/dart/analysis/context_builder.dart';
// ignore: implementation_imports
import 'package:analyzer/src/dart/analysis/driver.dart';
// ignore: implementation_imports
import 'package:analyzer/src/dart/analysis/file_content_cache.dart';
import 'package:analyzer_plugin/plugin/plugin.dart';
import 'package:analyzer_plugin/protocol/protocol_generated.dart' as plugin;

import '../analyzers/lint_analyzer/lint_analysis_config.dart';
import '../analyzers/lint_analyzer/lint_analyzer.dart';
import '../analyzers/lint_analyzer/metrics/metrics_list/number_of_parameters_metric.dart';
import '../analyzers/lint_analyzer/metrics/metrics_list/source_lines_of_code/source_lines_of_code_metric.dart';
import '../config_builder/config_builder.dart';
import '../config_builder/models/analysis_options.dart';
import '../utils/analyzer_utils.dart';
import '../utils/yaml_utils.dart';
import 'analyzer_plugin_utils.dart';

final _byteStore = createByteStore(PhysicalResourceProvider.INSTANCE);

class AnalyzerPlugin extends ServerPlugin {
  static const _analyzer = LintAnalyzer();

  late final FileContentCache _fileContentCache;

  var _filesFromSetPriorityFilesRequest = <String>[];
  final _configs = <AnalysisDriverGeneric, LintAnalysisConfig>{};

  @override
  String get contactInfo =>
      'https://github.com/dart-code-checker/dart-code-metrics/issues';

  @override
  List<String> get fileGlobsToAnalyze => const ['*.dart'];

  @override
  String get name => 'Dart Code Metrics';

  @override
  String get version => '1.0.0-alpha.0';

  AnalyzerPlugin(ResourceProvider provider)
      : super(resourceProvider: provider) {
    _fileContentCache = FileContentCache(resourceProvider);
  }
/*
  @override
  void contentChanged(List<String> paths) {
    // super.driverForPath(path)?.addFile(path);
    logLine('[contentChanged][path: $path]');
    final driver = super.driverForPath(path);
    if (driver is AnalysisDriver) {
      driver.changeFile(path);
      runZonedGuarded(
        () async {
          final affectedFiles = await driver.applyPendingFileChanges();
          await _analyzeFiles(driver, affectedFiles);
        },
        (e, stackTrace) {
          logLine('[exception][e: $e][stackTrace: $stackTrace]');
          channel.sendNotification(
            plugin.PluginErrorParams(false, e.toString(), stackTrace.toString())
                .toNotification(),
          );
        },
      );
    }
  }
*/

  @override
  Future<void> afterNewContextCollection({
    required AnalysisContextCollection contextCollection,
  }) {
    if (contextCollection.contexts.isEmpty) {
      final error = StateError('Unexpected empty context');
      channel.sendNotification(plugin.PluginErrorParams(
        true,
        error.message,
        error.stackTrace.toString(),
      ).toNotification());

      throw error;
    }

    final contextRoot2 = contextCollection.contexts.first.contextRoot;
    logLine(
        '[create][contextRoots: ${contextCollection.contexts.map((e) => e.contextRoot.root.path)}]');

    final builder = ContextBuilderImpl(resourceProvider: resourceProvider);
    final context = builder.createContext(
      contextRoot: contextRoot2,
      byteStore: _byteStore,
      fileContentCache: _fileContentCache,
    );
    final dartDriver = context.driver;
    final config = _createConfig(dartDriver, contextRoot2.root.path);

//    if (config == null) {
//      return dartDriver;
//    }

    // Temporary disable deprecation check
    //
    // final deprecations = checkConfigDeprecatedOptions(
    //   config,
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
      () async {
        final filesToAnalyze = contextRoot2.analyzedFiles().toList();
        await _analyzeFiles(dartDriver, filesToAnalyze);
        // dartDriver.results.listen((analysisResult) {
        //   if (analysisResult is ResolvedUnitResult) {
        //     _processResult(dartDriver, analysisResult);
        //   }
        // });
      },
      (e, stackTrace) {
        logLine('[exception][e: $e][stackTrace: $stackTrace]');
        channel.sendNotification(
          plugin.PluginErrorParams(false, e.toString(), stackTrace.toString())
              .toNotification(),
        );
      },
    );

    return super
        .afterNewContextCollection(contextCollection: contextCollection);
  }

  Future<void> _analyzeFiles(
    AnalysisDriver dartDriver,
    List<String> filesToAnalyze,
  ) async {
    logLine(
      '[analyzeFiles][root: ${dartDriver.name}][filesToAnalyze: $filesToAnalyze]',
    );
    final analysisSession = dartDriver.currentSession;
    for (final path in filesToAnalyze) {
      if (path.endsWith('.dart')) {
        logLine('  [path: $path]');
        final analysisResult = await analysisSession.getResolvedUnit(path);
        if (analysisResult is ResolvedUnitResult) {
          logLine('    [has ResolvedUnitResult]');
          _processResult(dartDriver, analysisResult);
          logLine('    processed');
        }
      }
    }
    dartDriver.clearLibraryContext();
  }

  @override
  void logLine(String line) {
    io.File('/Users/dmitry/Development/plugin_log.txt').writeAsStringSync(
      '$line\n',
      mode: io.FileMode.append,
      flush: true,
    );
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
      final analysisResult = await getResolvedUnitResult(parameters.file);

/*
      final fixes = _check(driver, analysisResult).where((fix) {
        final location = fix.error.location;

        return location.file == parameters.file &&
            location.offset <= parameters.offset &&
            parameters.offset <= location.offset + location.length &&
            fix.fixes.isNotEmpty;
      }).toList();

      return plugin.EditGetFixesResult(fixes);
*/
      return plugin.EditGetFixesResult([]);
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
      if (driver.analysisContext?.contextRoot.isAnalyzed(analysisResult.path) ??
          false) {
        final fixes = _check(driver, analysisResult);

        channel.sendNotification(
          plugin.AnalysisErrorsParams(
            analysisResult.path,
            fixes.map((fix) => fix.error).toList(),
          ).toNotification(),
        );
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

    if (config != null) {
      final root = driver.analysisContext?.contextRoot.root.path;

      final report = _analyzer.runPluginAnalysis(analysisResult, config, root!);

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

  LintAnalysisConfig? _createConfig(AnalysisDriver driver, String rootPath) {
    final file = driver.analysisContext?.contextRoot.optionsFile;
    if (file != null && file.exists) {
      final options = AnalysisOptions(
        file.path,
        yamlMapToDartMap(
          AnalysisOptionsProvider(driver.sourceFactory)
              .getOptionsFromFile(file),
        ),
      );
      final config = ConfigBuilder.getLintConfigFromOptions(options);
      final lintConfig = ConfigBuilder.getLintAnalysisConfig(
        config,
        options.folderPath ?? rootPath,
        classMetrics: const [],
        functionMetrics: [
          NumberOfParametersMetric(config: config.metrics),
          SourceLinesOfCodeMetric(config: config.metrics),
        ],
      );

      _configs[driver] = lintConfig;

      return lintConfig;
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
/*
    final filesToFullyResolve = {
      // Ensure these go first, since they're actually considered priority; ...
      ..._filesFromSetPriorityFilesRequest,

      // ... all other files need to be analyzed, but don't trump priority
      for (final driver2 in driverMap.values)
        ...(driver2 as AnalysisDriver).addedFiles,
    };

    // From ServerPlugin.handleAnalysisSetPriorityFiles.
    final filesByDriver = <AnalysisDriverGeneric, List<String>>{};
    for (final file in filesToFullyResolve) {
      final contextRoot = contextRootContaining(file);
      if (contextRoot != null) {
        // TODO(dkrutskikh): Which driver should we use if there is no context root?
        final driver = driverMap[contextRoot];
        if (driver != null) {
          filesByDriver.putIfAbsent(driver, () => <String>[]).add(file);
        }
      }
    }
    filesByDriver.forEach((driver, files) {
      driver.priorityFiles = files;
    });
*/
  }
}
