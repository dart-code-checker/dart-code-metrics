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
      '${runner?.executableName} $name [arguments] <directories>';

  AnalyzeCommand() {
    _addFlags();
  }

  @override
  Future<void> runCommand() async {
    final parsedArgs = ParsedArguments(
      excludePath: argResults[FlagNames.exclude] as String,
      metricsConfig: {
        for (final metric in getMetrics(config: {}))
          if (argResults.wasParsed(metric.id))
            metric.id: argResults[metric.id] as Object,
      },
    );

    final noCongratulate = argResults[FlagNames.noCongratulate] as bool;

    final config = ConfigBuilder.getLintConfigFromArgs(parsedArgs);

    final lintAnalyserResult = await _analyzer.runCliAnalysis(
      argResults.rest,
      argResults[FlagNames.rootFolder] as String,
      config,
      sdkPath: findSdkPath(),
    );

    await _analyzer
        .getReporter(
          name: argResults[FlagNames.reporter] as String,
          output: stdout,
          reportFolder: argResults[FlagNames.reportFolder] as String,
        )
        ?.report(
          lintAnalyserResult,
          summary: _analyzer.getSummary(lintAnalyserResult),
          additionalParams: LintReportParams(congratulate: !noCongratulate),
        );

    if (hasIssueWithSevetiry(lintAnalyserResult, Severity.error)) {
      exit(3);
    } else if ((argResults[FlagNames.fatalWarnings] as bool) &&
        hasIssueWithSevetiry(lintAnalyserResult, Severity.warning)) {
      exit(2);
    }

    final maximumAllowedLevel = MetricValueLevel.fromString(
      argResults[FlagNames.setExitOnViolationLevel] as String?,
    );

    if (maximumAllowedLevel != null &&
        maxMetricViolationLevel(lintAnalyserResult) >= maximumAllowedLevel) {
      exit(2);
    }

    if (((argResults[FlagNames.fatalPerformance] as bool) &&
            hasIssueWithSevetiry(lintAnalyserResult, Severity.performance)) ||
        ((argResults[FlagNames.fatalStyle] as bool) &&
            hasIssueWithSevetiry(lintAnalyserResult, Severity.style))) {
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
        valueHelp: '${metric.documentation.recomendedThreshold}',
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
