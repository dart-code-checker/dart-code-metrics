// ignore_for_file: public_member_api_docs

import 'dart:io';

import 'package:collection/collection.dart';

import '../../analyzers/lint_analyzer/lint_analyzer.dart';
import '../../analyzers/lint_analyzer/metrics/metrics_factory.dart';
import '../../analyzers/lint_analyzer/metrics/models/metric_value_level.dart';
import '../../analyzers/lint_analyzer/models/severity.dart';
import '../../analyzers/lint_analyzer/reporters/lint_report_params.dart';
import '../../analyzers/lint_analyzer/utils/report_utils.dart';
import '../../config_builder/config_builder.dart';
import '../../config_builder/models/deprecated_option.dart';
import '../../logger/logger.dart';
import '../models/flag_names.dart';
import '../models/parsed_arguments.dart';
import 'base_command.dart';

class AnalyzeCommand extends BaseCommand {
  final LintAnalyzer _analyzer;

  final Logger _logger;

  @override
  String get name => 'analyze';

  @override
  String get description =>
      'Collect code metrics, rules and anti-patterns violations.';

  @override
  String get invocation =>
      '${runner?.executableName} $name [arguments] <directories>';

  AnalyzeCommand(this._logger) : _analyzer = LintAnalyzer(_logger) {
    _addFlags();
  }

  @override
  Future<void> runCommand() async {
    _logger
      ..isSilent = isNoCongratulate
      ..isVerbose = isVerbose
      ..progress.start('Analyzing');

    final parsedArgs = ParsedArguments(
      excludePath: argResults[FlagNames.exclude] as String,
      metricsConfig: {
        for (final metric in getMetrics(config: {}))
          if (argResults.wasParsed(metric.id))
            metric.id: argResults[metric.id] as Object,
      },
    );

    final config = ConfigBuilder.getLintConfigFromArgs(parsedArgs);

    final lintAnalyzerResult = await _analyzer.runCliAnalysis(
      argResults.rest,
      argResults[FlagNames.rootFolder] as String,
      config,
      sdkPath: findSdkPath(),
    );

    _logger.progress.complete('Analysis is completed. Preparing the results:');

    await _analyzer
        .getReporter(
          name: argResults[FlagNames.reporter] as String,
          output: stdout,
          reportFolder: argResults[FlagNames.reportFolder] as String,
        )
        ?.report(
          lintAnalyzerResult,
          summary: _analyzer.getSummary(lintAnalyzerResult),
          additionalParams: LintReportParams(congratulate: !isNoCongratulate),
        );

    if (hasIssueWithSeverity(lintAnalyzerResult, Severity.error)) {
      exit(3);
    } else if ((argResults[FlagNames.fatalWarnings] as bool) &&
        hasIssueWithSeverity(lintAnalyzerResult, Severity.warning)) {
      exit(2);
    }

    final maximumAllowedLevel = MetricValueLevel.fromString(
      argResults[FlagNames.setExitOnViolationLevel] as String?,
    );

    if (maximumAllowedLevel != null &&
        maxMetricViolationLevel(lintAnalyzerResult) >= maximumAllowedLevel) {
      exit(2);
    }

    if (((argResults[FlagNames.fatalPerformance] as bool) &&
            hasIssueWithSeverity(lintAnalyzerResult, Severity.performance)) ||
        ((argResults[FlagNames.fatalStyle] as bool) &&
            hasIssueWithSeverity(lintAnalyzerResult, Severity.style))) {
      exit(1);
    }
  }

  void _addFlags() {
    _usesReporterOption();
    _usesMetricsThresholdOptions();
    addCommonFlags();
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
          FlagNames.checkstyleReporter,
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
        valueHelp: '${metric.documentation.recommendedThreshold}',
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
      )
      ..addFlag(
        FlagNames.fatalStyle,
        help: 'Treat style level issues as fatal.',
      )
      ..addFlag(
        FlagNames.fatalPerformance,
        help: 'Treat performance level issues as fatal.',
      )
      ..addFlag(
        FlagNames.fatalWarnings,
        help: 'Treat warning level issues as fatal.',
// TODO(dkrutrkikh): activate on next major version
//        defaultsTo: true,
      );
  }
}
