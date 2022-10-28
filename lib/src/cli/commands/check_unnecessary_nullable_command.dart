// ignore_for_file: public_member_api_docs

import 'dart:io';

import '../../analyzers/unnecessary_nullable_analyzer/reporters/unnecessary_nullable_report_params.dart';
import '../../analyzers/unnecessary_nullable_analyzer/unnecessary_nullable_analyzer.dart';
import '../../config_builder/config_builder.dart';
import '../../logger/logger.dart';
import '../models/flag_names.dart';
import 'base_command.dart';

class CheckUnnecessaryNullableCommand extends BaseCommand {
  final UnnecessaryNullableAnalyzer _analyzer;

  final Logger _logger;

  @override
  String get name => 'check-unnecessary-nullable';

  @override
  String get description =>
      'Check unnecessary nullable parameters in functions, methods, constructors.';

  @override
  String get invocation =>
      '${runner?.executableName} $name [arguments] <directories>';

  CheckUnnecessaryNullableCommand(this._logger)
      : _analyzer = UnnecessaryNullableAnalyzer(_logger) {
    _addFlags();
  }

  @override
  Future<void> runCommand() async {
    _logger
      ..isSilent = isNoCongratulate
      ..isVerbose = isVerbose
      ..progress.start('Checking unnecessary nullable parameters');

    final rootFolder = argResults[FlagNames.rootFolder] as String;
    final folders = argResults.rest;
    final excludePath = argResults[FlagNames.exclude] as String;
    final reporterName = argResults[FlagNames.reporter] as String;
    final isMonorepo = argResults[FlagNames.isMonorepo] as bool;
    final shouldPrintConfig = argResults[FlagNames.printConfig] as bool;

    final config = ConfigBuilder.getUnnecessaryNullableConfigFromArgs(
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
              UnnecessaryNullableReportParams(congratulate: !isNoCongratulate),
        );

    if (unusedCodeResult.isNotEmpty &&
        (argResults[FlagNames.fatalOnFound] as bool)) {
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
        help:
            'Treat all exported code with parameters as non-nullable by default.',
      );
  }

  void _usesExitOption() {
    argParser
      ..addSeparator('')
      ..addFlag(
        FlagNames.fatalOnFound,
        help: 'Treat found unnecessary nullable parameters as fatal.',
        defaultsTo: true,
      );
  }
}
