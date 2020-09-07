import 'dart:io';

import 'package:dart_code_metrics/metrics_analyzer.dart';
import 'package:dart_code_metrics/reporters.dart';
import 'package:dart_code_metrics/src/cli/arguments_parser.dart';
import 'package:dart_code_metrics/src/cli/arguments_validation.dart';
import 'package:dart_code_metrics/src/cli/arguments_validation_exceptions.dart';
import 'package:dart_code_metrics/src/models/violation_level.dart';
import 'package:dart_code_metrics/src/reporters/utility_selector.dart';
import 'package:glob/glob.dart';
import 'package:path/path.dart' as p;

final _parser = argumentsParser();

Future<void> main(List<String> args) async {
  try {
    final arguments = _parser.parse(args);

    if (arguments[helpFlagName] as bool) {
      _showUsageAndExit(0);
    }

    validateArguments(arguments);

    await _runAnalysis(
        arguments[rootFolderName] as String,
        arguments.rest,
        arguments[ignoredFilesName] as String,
        int.tryParse(arguments[cyclomaticComplexityThreshold] as String ?? ''),
        int.tryParse(arguments[linesOfExecutableCodeThreshold] as String ?? ''),
        int.tryParse(arguments[numberOfArgumentsThreshold] as String ?? ''),
        int.tryParse(arguments[numberOfMethodsThreshold] as String ?? ''),
        arguments[reporterName] as String,
        arguments[verboseName] as bool,
        ViolationLevel.fromString(
            arguments[setExitOnViolationLevel] as String));
  } on FormatException catch (e) {
    print('${e.message}\n');
    _showUsageAndExit(1);
  } on InvalidArgumentException catch (e) {
    print('${e.message}\n');
    _showUsageAndExit(1);
  }
}

void _showUsageAndExit(int exitCode) {
  print(usageHeader);
  print(_parser.usage);
  exit(exitCode);
}

Future<void> _runAnalysis(
    String rootFolder,
    Iterable<String> analysisDirectories,
    String ignoreFilesPattern,
    int cyclomaticComplexityThreshold,
    int linesOfExecutableCodeThreshold,
    int numberOfArgumentsWarningLevel,
    int numberOfMethodsWarningLevel,
    String reporterType,
    bool verbose,
    ViolationLevel setExitOnViolationLevel) async {
  var dartFilePaths = analysisDirectories.expand((directory) =>
      Glob('$directory**.dart')
          .listSync(root: rootFolder, followLinks: false)
          .whereType<File>()
          .map((entity) => entity.path));

  if (ignoreFilesPattern.isNotEmpty) {
    final ignoreFilesGlob = Glob(ignoreFilesPattern);
    dartFilePaths =
        dartFilePaths.where((path) => !ignoreFilesGlob.matches(path));
  }

  final analysisOptionsFile =
      File(p.absolute(rootFolder, analysisOptionsFileName));

  final options = analysisOptionsFile.existsSync()
      ? await analysisOptionsFromFile(analysisOptionsFile)
      : null;

  final store = MetricsRecordsStore.store();
  final analyzer = MetricsAnalyzer(store, options: options);
  final runner = MetricsAnalysisRunner(analyzer, store, dartFilePaths,
      rootFolder: rootFolder)
    ..run();

  final config = Config(
      cyclomaticComplexityWarningLevel: cyclomaticComplexityThreshold ??
          options.metricsConfig.cyclomaticComplexityWarningLevel,
      linesOfExecutableCodeWarningLevel: linesOfExecutableCodeThreshold ??
          options.metricsConfig.linesOfExecutableCodeWarningLevel,
      numberOfArgumentsWarningLevel: numberOfArgumentsWarningLevel ??
          options.metricsConfig.numberOfArgumentsWarningLevel,
      numberOfMethodsWarningLevel: numberOfMethodsWarningLevel ??
          options.metricsConfig.numberOfMethodsWarningLevel);

  Reporter reporter;

  switch (reporterType) {
    case 'console':
      reporter = ConsoleReporter(reportConfig: config, reportAll: verbose);
      break;
    case 'json':
      reporter = JsonReporter(reportConfig: config);
      break;
    case 'html':
      reporter = HtmlReporter(reportConfig: config);
      break;
    case 'codeclimate':
      reporter = CodeClimateReporter(reportConfig: config);
      break;
    default:
      throw ArgumentError.value(reporterType, 'reporter');
  }

  reporter.report(runner.results()).forEach(print);

  if (setExitOnViolationLevel != null &&
      UtilitySelector.maxViolationLevel(runner.results(), config) >=
          setExitOnViolationLevel) {
    exit(2);
  }
}
