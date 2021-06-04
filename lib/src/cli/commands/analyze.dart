import 'dart:io';

import 'package:collection/collection.dart';

import '../../analyzers/lint_analyzer/lint_analyzer.dart';
import '../../analyzers/lint_analyzer/metrics/metrics_factory.dart';
import '../../analyzers/lint_analyzer/metrics/models/metric_value_level.dart';
import '../../analyzers/lint_analyzer/reporters/utility_selector.dart';
import '../../config_builder/config_builder.dart';
import '../../config_builder/models/analysis_options.dart';
import '../../config_builder/models/deprecated_option.dart';
import '../models/flag_names.dart';
import '../models/parsed_arguments.dart';
import 'base_command.dart';

class AnalyzeCommand extends BaseCommand {
  static const _analyzer = LintAnalyzer();

  @override
  String get name => 'analyze';

  @override
  String get description =>
      'Collect code metrics, rules and anti-patterns violations.';

  @override
  String get invocation =>
      '${runner.executableName} $name [arguments] <directories>';

  AnalyzeCommand() {
    _addFlags();
  }

  @override
  void validateCommand() {
    validateRootFolderExist();
    validateTargetDirectories();
  }

  @override
  Future<void> runCommand() async {
    final parsedArgs = ParsedArguments(
      rootFolder: argResults[FlagNames.rootFolder] as String,
      reporterName: argResults[FlagNames.reporter] as String,
      reportFolder: argResults[FlagNames.reportFolder] as String,
      maximumAllowedLevel: MetricValueLevel.fromString(
        argResults[FlagNames.setExitOnViolationLevel] as String?,
      ),
      folders: argResults.rest,
      excludePath: argResults[FlagNames.exclude] as String,
      metricsConfig: {
        for (final metric in getMetrics(config: {}))
          if (argResults.wasParsed(metric.id))
            metric.id: argResults[metric.id] as Object,
      },
    );

    final options = await analysisOptionsFromFilePath(parsedArgs.rootFolder);
    final config = ConfigBuilder.getConfig(options, parsedArgs);
    final lintConfig =
        ConfigBuilder.getLintConfig(config, parsedArgs.rootFolder);

    final lintAnalyserResult = await _analyzer.runCliAnalysis(
      parsedArgs.folders,
      parsedArgs.rootFolder,
      lintConfig,
    );

    await _analyzer
        .getReporter(
          name: parsedArgs.reporterName,
          output: stdout,
          config: config,
          reportFolder: parsedArgs.reportFolder,
        )
        ?.report(lintAnalyserResult);

    if (parsedArgs.maximumAllowedLevel != null &&
        UtilitySelector.maxViolationLevel(lintAnalyserResult) >=
            parsedArgs.maximumAllowedLevel!) {
      exit(2);
    }
  }

  void _addFlags() {
    _usesReporterOption();
    _usesMetricsThresholdOptions();
    usesRootFolderOption();
    usesExcludeOption();
    _usesExitOption();
  }

  void _usesReporterOption() {
    argParser
      ..addSeparator('')
      ..addOption(
        FlagNames.reporter,
        abbr: 'r',
        help: 'The format of the output of the analysis.',
        valueHelp: FlagNames.consoleReporter,
        allowed: [
          FlagNames.consoleReporter,
          FlagNames.consoleVerboseReporter,
          FlagNames.codeClimateReporter,
          FlagNames.githubReporter,
          FlagNames.gitlabCodeClimateReporter,
          FlagNames.htmlReporter,
          FlagNames.jsonReporter,
        ],
        defaultsTo: FlagNames.consoleReporter,
      )
      ..addOption(
        FlagNames.reportFolder,
        abbr: 'o',
        help: 'Write HTML output to OUTPUT.',
        valueHelp: 'OUTPUT',
        defaultsTo: 'metrics',
      );
  }

  void _usesMetricsThresholdOptions() {
    argParser.addSeparator('');

    for (final metric in getMetrics(config: {})) {
      final deprecation = deprecatedOptions
          .firstWhereOrNull((option) => option.deprecated == metric.id);
      final deprecationMessage = deprecation != null
          ? ' (deprecated, will be removed in ${deprecation.supportUntilVersion} version)'
          : '';

      argParser.addOption(
        metric.id,
        help: '${metric.documentation.name} threshold$deprecationMessage.',
        valueHelp: '${metric.threshold}',
        callback: (i) {
          if (i != null && int.tryParse(i) == null) {
            print(
              "'$i' invalid value for argument ${metric.documentation.name}",
            );
          }
        },
      );
    }
  }

  void _usesExitOption() {
    argParser
      ..addSeparator('')
      ..addOption(
        FlagNames.setExitOnViolationLevel,
        allowed: ['noted', 'warning', 'alarm'],
        valueHelp: 'warning',
        help:
            'Set exit code 2 if code violations same or higher level than selected are detected.',
      );
  }
}
