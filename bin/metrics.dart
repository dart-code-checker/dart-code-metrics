import 'dart:io';

import 'package:args/args.dart';
import 'package:dart_code_metrics/config.dart';
import 'package:dart_code_metrics/metrics.dart';
import 'package:dart_code_metrics/metrics_analyzer.dart';
import 'package:dart_code_metrics/reporters.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/lint_analyzer.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/metrics_factory.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/models/metric_value_level.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/reporters/utility_selector.dart';
import 'package:dart_code_metrics/src/cli/arguments_parser.dart';
import 'package:dart_code_metrics/src/cli/arguments_validation.dart';
import 'package:dart_code_metrics/src/cli/arguments_validation_exceptions.dart';
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
  } on ArgParserException catch (e) {
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

  print(config.metrics);

  final lintAnalyserResult = await const LintAnalyzer()
      .runCliAnalysis(arguments.rest, rootFolder, config);

  await reporter(
    name: arguments[reporterName] as String,
    output: stdout,
    config: config,
    reportFolder: arguments[reportFolder] as String,
  )?.report(lintAnalyserResult);

  final exitOnViolationLevel = MetricValueLevel.fromString(
    arguments[setExitOnViolationLevel] as String?,
  );
  if (exitOnViolationLevel != null &&
      UtilitySelector.maxViolationLevel(lintAnalyserResult) >=
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
