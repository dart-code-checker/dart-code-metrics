// ignore_for_file: public_member_api_docs

import 'dart:io';

import '../../analyzers/lint_analyzer/lint_analyzer.dart';
import '../../analyzers/lint_analyzer/metrics/metrics_factory.dart';
import '../../analyzers/lint_analyzer/metrics/models/metric_value_level.dart';
import '../../analyzers/lint_analyzer/models/lint_file_report.dart';
import '../../analyzers/lint_analyzer/models/severity.dart';
import '../../analyzers/lint_analyzer/reporters/lint_report_params.dart';
import '../../analyzers/lint_analyzer/reporters/reporters_list/json/lint_json_reporter.dart';
import '../../analyzers/lint_analyzer/utils/report_utils.dart';
import '../../config_builder/config_builder.dart';
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

    final parsedArgs = ParsedArguments.fromArgs(argResults);

    final config = ConfigBuilder.getLintConfigFromArgs(parsedArgs);

    final lintAnalyzerResult = await _analyzer.runCliAnalysis(
      argResults.rest,
      parsedArgs.rootFolder,
      config,
      sdkPath: findSdkPath(),
    );

    _logger.progress.complete('Analysis is completed. Preparing the results:');

    final jsonReportPath = parsedArgs.jsonReportPath;
    if (jsonReportPath != null) {
      final jsonReporter =
          LintJsonReporter.toFile(jsonReportPath, parsedArgs.rootFolder);
      await jsonReporter.report(
        lintAnalyzerResult,
        additionalParams: LintReportParams(
          congratulate: true,
          summary: _analyzer.getSummary(lintAnalyzerResult),
        ),
      );
    }

    await _analyzer
        .getReporter(
          name: argResults[FlagNames.reporter] as String,
          output: stdout,
          reportFolder: argResults[FlagNames.reportFolder] as String,
        )
        ?.report(
          lintAnalyzerResult,
          additionalParams: LintReportParams(
            congratulate: !isNoCongratulate,
            summary: _analyzer.getSummary(lintAnalyzerResult),
          ),
        );

    _checkSeverity(lintAnalyzerResult);
  }

  void _checkSeverity(Iterable<LintFileReport> lintAnalyzerResult) {
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
      )
      ..addOption(
        FlagNames.jsonReportPath,
        help: 'Path to the JSON file with the output of the analysis.',
        valueHelp: 'path/to/file.json',
        defaultsTo: null,
      );
  }

  void _usesMetricsThresholdOptions() {
    argParser.addSeparator('');

    for (final metric in getMetrics(config: {})) {
      argParser.addOption(
        metric.id,
        help: '${metric.documentation.name} threshold.',
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
        defaultsTo: true,
      );
  }
}
