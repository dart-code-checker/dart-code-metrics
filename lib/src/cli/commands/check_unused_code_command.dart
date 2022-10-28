// ignore_for_file: public_member_api_docs

import 'dart:io';

import '../../analyzers/unused_code_analyzer/reporters/unused_code_report_params.dart';
import '../../analyzers/unused_code_analyzer/unused_code_analyzer.dart';
import '../../config_builder/config_builder.dart';
import '../../logger/logger.dart';
import '../models/flag_names.dart';
import 'base_command.dart';

class CheckUnusedCodeCommand extends BaseCommand {
  final UnusedCodeAnalyzer _analyzer;

  final Logger _logger;

  @override
  String get name => 'check-unused-code';

  @override
  String get description => 'Check unused code in *.dart files.';

  @override
  String get invocation =>
      '${runner?.executableName} $name [arguments] <directories>';

  CheckUnusedCodeCommand(this._logger)
      : _analyzer = UnusedCodeAnalyzer(_logger) {
    _addFlags();
  }

  @override
  Future<void> runCommand() async {
    _logger
      ..isSilent = isNoCongratulate
      ..isVerbose = isVerbose
      ..progress.start('Checking unused code');

    final rootFolder = argResults[FlagNames.rootFolder] as String;
    final folders = argResults.rest;
    final excludePath = argResults[FlagNames.exclude] as String;
    final reporterName = argResults[FlagNames.reporter] as String;
    final isMonorepo = argResults[FlagNames.isMonorepo] as bool;
    final shouldPrintConfig = argResults[FlagNames.printConfig] as bool;

    final config = ConfigBuilder.getUnusedCodeConfigFromArgs(
      [excludePath],
      isMonorepo: isMonorepo,
      shouldPrintConfig: shouldPrintConfig,
    );

    final unusedCodeResult = await _analyzer.runCliAnalysis(
      folders,
      rootFolder,
      config,
      sdkPath: findSdkPath(),
    );

    _logger.progress.complete('Analysis is completed. Preparing the results:');

    await _analyzer
        .getReporter(
          name: reporterName,
          output: stdout,
        )
        ?.report(
          unusedCodeResult,
          additionalParams:
              UnusedCodeReportParams(congratulate: !isNoCongratulate),
        );

    if (unusedCodeResult.isNotEmpty &&
        (argResults[FlagNames.fatalOnUnused] as bool)) {
      exit(1);
    }
  }

  void _addFlags() {
    _usesReporterOption();
    addCommonFlags();
    _usesIsMonorepoOption();
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
          FlagNames.jsonReporter,
        ],
        defaultsTo: FlagNames.consoleReporter,
      );
  }

  void _usesIsMonorepoOption() {
    argParser
      ..addSeparator('')
      ..addFlag(
        FlagNames.isMonorepo,
        help: 'Treat all exported code as unused by default.',
      );
  }

  void _usesExitOption() {
    argParser
      ..addSeparator('')
      ..addFlag(
        FlagNames.fatalOnUnused,
        help: 'Treat find unused code as fatal.',
        defaultsTo: true,
      );
  }
}
