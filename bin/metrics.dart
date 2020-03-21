import 'dart:io';

import 'package:dart_code_metrics/metrics_analyzer.dart';
import 'package:dart_code_metrics/reporters.dart';
import 'package:dart_code_metrics/src/cli/arguments_parser.dart';
import 'package:dart_code_metrics/src/cli/arguments_validation.dart';
import 'package:dart_code_metrics/src/cli/arguments_validation_exceptions.dart';
import 'package:glob/glob.dart';

final parser = argumentsParser();

void main(List<String> args) {
  try {
    final arguments = parser.parse(args);

    if (arguments[helpFlagName] as bool) {
      _showUsageAndExit(0);
    }

    validateArguments(arguments);

    _runAnalysis(
        arguments[rootFolderName] as String,
        arguments.rest,
        arguments[ignoredFilesName] as String,
        int.parse(arguments[cyclomaticComplexityThreshold] as String),
        int.parse(arguments[linesOfCodeThreshold] as String),
        int.parse(arguments[numberOfArgumentsThreshold] as String),
        arguments[reporterOptionName] as String,
        arguments[verboseName] as bool);
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
  print(parser.usage);
  exit(exitCode);
}

void _runAnalysis(
    String rootFolder,
    Iterable<String> analysisDirectories,
    String ignoreFilesPattern,
    int cyclomaticComplexityThreshold,
    int linesOfCodeThreshold,
    int numberOfArgumentsWarningLevel,
    String reporterType,
    bool verbose) {
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

  final recorder = MetricsAnalysisRecorder();
  final analyzer = MetricsAnalyzer(recorder);
  final runner = MetricsAnalysisRunner(recorder, analyzer, dartFilePaths,
      rootFolder: rootFolder)
    ..run();

  final config = Config(
      cyclomaticComplexityWarningLevel: cyclomaticComplexityThreshold,
      linesOfCodeWarningLevel: linesOfCodeThreshold,
      numberOfArgumentsWarningLevel: numberOfArgumentsWarningLevel);

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
}
