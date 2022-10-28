// ignore_for_file: public_member_api_docs

import 'dart:io';

import '../../analyzers/unused_files_analyzer/reporters/unused_files_report_params.dart';
import '../../analyzers/unused_files_analyzer/unused_files_analyzer.dart';
import '../../config_builder/config_builder.dart';
import '../../logger/logger.dart';
import '../models/flag_names.dart';
import 'base_command.dart';

class CheckUnusedFilesCommand extends BaseCommand {
  final UnusedFilesAnalyzer _analyzer;

  final Logger _logger;

  @override
  String get name => 'check-unused-files';

  @override
  String get description => 'Check unused *.dart files.';

  @override
  String get invocation =>
      '${runner?.executableName} $name [arguments] <directories>';

  CheckUnusedFilesCommand(this._logger)
      : _analyzer = UnusedFilesAnalyzer(_logger) {
    _addFlags();
  }

  @override
  Future<void> runCommand() async {
    _logger
      ..isSilent = isNoCongratulate
      ..isVerbose = isVerbose
      ..progress.start('Checking unused files');

    final rootFolder = argResults[FlagNames.rootFolder] as String;
    final folders = argResults.rest;
    final excludePath = argResults[FlagNames.exclude] as String;
    final reporterName = argResults[FlagNames.reporter] as String;
    final isMonorepo = argResults[FlagNames.isMonorepo] as bool;
    final deleteFiles = argResults[FlagNames.deleteFiles] as bool;
    final shouldPrintConfig = argResults[FlagNames.printConfig] as bool;

    final config = ConfigBuilder.getUnusedFilesConfigFromArgs(
      [excludePath],
      isMonorepo: isMonorepo,
      shouldPrintConfig: shouldPrintConfig,
    );

    final unusedFilesResult = await _analyzer.runCliAnalysis(
      folders,
      rootFolder,
      config,
      sdkPath: findSdkPath(),
    );

    _logger.progress.complete('Analysis is completed. Preparing the results:');

    if (deleteFiles) {
      _analyzer.deleteAllUnusedFiles(unusedFilesResult);
    }

    await _analyzer
        .getReporter(
          name: reporterName,
          output: stdout,
        )
        ?.report(
          unusedFilesResult,
          additionalParams: UnusedFilesReportParams(
            congratulate: !isNoCongratulate,
            deleteUnusedFiles: deleteFiles,
          ),
        );

    if (unusedFilesResult.isNotEmpty &&
        (argResults[FlagNames.fatalOnUnused] as bool)) {
      exit(1);
    }
  }

  void _addFlags() {
    _usesReporterOption();
    addCommonFlags();
    _usesIsMonorepoOption();
    _usesExitOption();
    _usesDeleteUnusedFiles();
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
        help: 'Treat all exported files as unused by default.',
      );
  }

  void _usesExitOption() {
    argParser
      ..addSeparator('')
      ..addFlag(
        FlagNames.fatalOnUnused,
        help: 'Treat find unused file as fatal.',
        defaultsTo: true,
      );
  }

  void _usesDeleteUnusedFiles() {
    argParser
      ..addSeparator('')
      ..addFlag(
        FlagNames.deleteFiles,
        abbr: 'd',
        help: 'Delete all unused files.',
      );
  }
}
