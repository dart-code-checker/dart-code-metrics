import 'dart:io';

import 'package:args/args.dart';
import 'package:dart_code_metrics/metrics_analyzer.dart' as metrics;
import 'package:dart_code_metrics/reporters.dart';
import 'package:dart_code_metrics/src/cli/arguments_parser.dart';
import 'package:dart_code_metrics/src/cli/arguments_validation.dart';
import 'package:dart_code_metrics/src/cli/arguments_validation_exceptions.dart';
import 'package:dart_code_metrics/src/models/metric_value_level.dart';
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
    await _runAnalysis(arguments);
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

Future<void> _runAnalysis(ArgResults arguments) async {
  final rootFolder = arguments[rootFolderName] as String;

  final analysisOptionsFile =
      File(p.absolute(rootFolder, metrics.analysisOptionsFileName));

  final cyclomaticComplexityThreshold =
      int.tryParse(arguments[metrics.cyclomaticComplexityKey] as String? ?? '');
  final linesOfExecutableCodeThreshold = int.tryParse(
      arguments[metrics.linesOfExecutableCodeKey] as String? ?? '');
  final numberOfParametersWarningLevel =
      int.tryParse(arguments[metrics.numberOfParametersKey] as String? ?? '');
  final numberOfMethodsWarningLevel =
      int.tryParse(arguments[metrics.numberOfMethodsKey] as String? ?? '');
  final maximumNestingWarningLevel =
      int.tryParse(arguments[metrics.maximumNestingKey] as String? ?? '');
  final weightOfClassWarningLevel =
      double.tryParse(arguments[metrics.weightOfClassKey] as String? ?? '');
  final reporterType = arguments[reporterName] as String;
  final exitOnViolationLevel = MetricValueLevel.fromString(
      arguments[setExitOnViolationLevel] as String?);

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
    additionalExcludes: [arguments[excludedName] as String],
  );
  final runner = metrics.MetricsAnalysisRunner(
    analyzer,
    store,
    arguments.rest,
    rootFolder,
  );
  await runner.run();

  final config = metrics.Config(
    cyclomaticComplexityWarningLevel: cyclomaticComplexityThreshold,
    linesOfExecutableCodeWarningLevel: linesOfExecutableCodeThreshold,
    numberOfParametersWarningLevel: numberOfParametersWarningLevel,
    numberOfMethodsWarningLevel: numberOfMethodsWarningLevel,
    maximumNestingWarningLevel: maximumNestingWarningLevel,
    weightOfClassWarningLevel: weightOfClassWarningLevel,
  );

  Reporter reporter;

  switch (reporterType) {
    case consoleReporter:
      reporter = ConsoleReporter(reportConfig: config);
      break;
    case consoleVerboseReporter:
      reporter = ConsoleReporter(reportConfig: config, reportAll: true);
      break;
    case codeClimateReporter:
      reporter = CodeClimateReporter(reportConfig: config);
      break;
    case htmlReporter:
      reporter = HtmlReporter(
        reportConfig: config,
        reportFolder: arguments[reportFolder] as String,
      );
      break;
    case jsonReporter:
      reporter = JsonReporter(reportConfig: config);
      break;
    case githubReporter:
      reporter = GitHubReporter();
      break;
    case gitlabCodeClimateReporter:
      reporter = CodeClimateReporter(
        reportConfig: config,
        gitlabCompatible: true,
      );
      break;
    default:
      throw ArgumentError.value(reporterType, 'reporter');
  }

  (await reporter.report(runner.results())).forEach(print);

  if (exitOnViolationLevel != null &&
      UtilitySelector.maxViolationLevel(runner.results(), config) >=
          exitOnViolationLevel) {
    exit(2);
  }
}
