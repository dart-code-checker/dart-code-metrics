import 'dart:io';

import 'package:args/args.dart';
import 'package:dart_code_metrics/metrics_analyzer.dart';
import 'package:dart_code_metrics/reporters.dart';
import 'package:dart_code_metrics/src/cli/arguments_parser.dart';
import 'package:dart_code_metrics/src/cli/arguments_validation.dart';
import 'package:dart_code_metrics/src/cli/arguments_validation_exceptions.dart';
import 'package:dart_code_metrics/src/config/analysis_options.dart';
import 'package:dart_code_metrics/src/metrics_factory.dart';
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

Future<void> _runAnalysis(ArgResults arguments) async {
  final rootFolder = arguments[rootFolderName] as String;

  final analysisOptionsFile =
      File(p.absolute(rootFolder, analysisOptionsFileName));

  final options = await analysisOptionsFromFile(analysisOptionsFile);
  final config =
      Config.fromAnalysisOptions(options).merge(_configFromArgs(arguments));

  final store = MetricsRecordsStore.store();
  final analyzer = MetricsAnalyzer(store, config);

  final runner =
      MetricsAnalysisRunner(analyzer, store, arguments.rest, rootFolder);
  await runner.run();

  final reporterType = arguments[reporterName] as String;
  final exitOnViolationLevel = MetricValueLevel.fromString(
    arguments[setExitOnViolationLevel] as String?,
  );

  Reporter reporter;

  switch (reporterType) {
    case consoleReporter:
      reporter = ConsoleReporter();
      break;
    case consoleVerboseReporter:
      reporter = ConsoleReporter(reportAll: true);
      break;
    case codeClimateReporter:
      reporter = CodeClimateReporter(reportConfig: config);
      break;
    case htmlReporter:
      reporter = HtmlReporter(reportFolder: arguments[reportFolder] as String);
      break;
    case jsonReporter:
      reporter = JsonReporter();
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
      UtilitySelector.maxViolationLevel(runner.results()) >=
          exitOnViolationLevel) {
    exit(2);
  }
}

Config _configFromArgs(ArgResults arguments) => Config(
      excludePatterns: [arguments[excludedName] as String],
      excludeForMetricsPatterns: const [],
      metrics: {
        for (final metric in metrics(config: {}))
          if (arguments.wasParsed(metric.id))
            metric.id: arguments[metric.id] as Object,
        if (arguments.wasParsed(linesOfExecutableCodeKey))
          linesOfExecutableCodeKey:
              arguments[linesOfExecutableCodeKey] as Object,
      },
      rules: const {},
      antiPatterns: const {},
    );

void _showUsageAndExit(int exitCode) {
  print(usageHeader);
  print(_parser.usage);

  exit(exitCode);
}
