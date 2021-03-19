import 'dart:io';

import 'package:code_checker/checker.dart';
import 'package:code_checker/metrics.dart';
import 'package:dart_code_metrics/metrics_analyzer.dart' as metrics;
import 'package:dart_code_metrics/reporters.dart';
import 'package:dart_code_metrics/src/obsoleted/config/cli/arguments_parser.dart';
import 'package:dart_code_metrics/src/obsoleted/config/cli/arguments_validation.dart';
import 'package:dart_code_metrics/src/obsoleted/reporters/utility_selector.dart';
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
      int.tryParse(arguments[metrics.cyclomaticComplexityKey] as String ?? ''),
      int.tryParse(arguments[metrics.linesOfExecutableCodeKey] as String ?? ''),
      int.tryParse(arguments[metrics.numberOfArgumentsKey] as String ?? ''),
      int.tryParse(arguments[metrics.numberOfMethodsKey] as String ?? ''),
      int.tryParse(arguments[metrics.maximumNestingKey] as String ?? ''),
      double.tryParse(arguments[metrics.weightOfClassKey] as String ?? ''),
      arguments[reporterName] as String,
      arguments[verboseName] as bool,
      arguments[gitlabCompatibilityName] as bool,
      arguments[reportFolder] as String,
      MetricValueLevel.fromString(arguments[setExitOnViolationLevel] as String),
    );
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
  int maximumNestingWarningLevel,
  double weightOfClassWarningLevel,
  String reporterType,
  bool verbose,
  bool gitlab,
  String reportOutputFolder,
  MetricValueLevel setExitOnViolationLevel,
) async {
  final analysisOptionsFile =
      File(p.absolute(rootFolder, metrics.analysisOptionsFileName));

  final options = analysisOptionsFile.existsSync()
      ? await metrics.analysisOptionsFromFile(analysisOptionsFile)
      : const metrics.AnalysisOptions(
          excludePatterns: [],
          excludeForMetricsPatterns: [],
          metrics: {},
          metricsConfig: metrics.Config(),
          rules: {},
          antiPatterns: {},
        );

  final store = metrics.MetricsRecordsStore.store();
  final analyzer = metrics.MetricsAnalyzer(
    store,
    options: options,
    additionalExcludes: [ignoreFilesPattern],
  );
  final runner = metrics.MetricsAnalysisRunner(
    analyzer,
    store,
    analysisDirectories,
    rootFolder,
  );
  await runner.run();

  final config = metrics.Config(
    cyclomaticComplexityWarningLevel: cyclomaticComplexityThreshold ??
        options.metricsConfig.cyclomaticComplexityWarningLevel,
    linesOfExecutableCodeWarningLevel: linesOfExecutableCodeThreshold ??
        options.metricsConfig.linesOfExecutableCodeWarningLevel,
    numberOfArgumentsWarningLevel: numberOfArgumentsWarningLevel ??
        options.metricsConfig.numberOfArgumentsWarningLevel,
    numberOfMethodsWarningLevel: numberOfMethodsWarningLevel ??
        options.metricsConfig.numberOfMethodsWarningLevel,
    maximumNestingWarningLevel: maximumNestingWarningLevel ??
        options.metricsConfig.maximumNestingWarningLevel,
    weightOfClassWarningLevel: weightOfClassWarningLevel ??
        options.metricsConfig.weightOfClassWarningLevel,
  );

  Reporter reporter;

  switch (reporterType) {
    case 'console':
      reporter = ConsoleReporter(reportConfig: config, reportAll: verbose);
      break;
    case 'github':
      reporter = GitHubReporter();
      break;
    case 'json':
      reporter = JsonReporter(reportConfig: config);
      break;
    case 'html':
      reporter =
          HtmlReporter(reportConfig: config, reportFolder: reportOutputFolder);
      break;
    case 'codeclimate':
      reporter =
          CodeClimateReporter(reportConfig: config, gitlabCompatible: gitlab);
      break;
    default:
      throw ArgumentError.value(reporterType, 'reporter');
  }

  (await reporter.report(runner.results())).forEach(print);

  if (setExitOnViolationLevel != null &&
      UtilitySelector.maxViolationLevel(runner.results(), config) >=
          setExitOnViolationLevel) {
    exit(2);
  }
}
