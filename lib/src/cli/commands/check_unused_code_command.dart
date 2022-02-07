// ignore_for_file: public_member_api_docs

import 'dart:io';

import '../../analyzers/unused_code_analyzer/reporters/unused_code_report_params.dart';
import '../../analyzers/unused_code_analyzer/unused_code_analyzer.dart';
import '../../config_builder/config_builder.dart';
import '../models/flag_names.dart';
import 'base_command.dart';

class CheckUnusedCodeCommand extends BaseCommand {
  static const _analyzer = UnusedCodeAnalyzer();

  @override
  String get name => 'check-unused-code';

  @override
  String get description => 'Check unused code in *.dart files.';

  @override
  String get invocation =>
      '${runner?.executableName} $name [arguments] <directories>';

  CheckUnusedCodeCommand() {
    _addFlags();
  }

  @override
  Future<void> runCommand() async {
    final rootFolder = argResults[FlagNames.rootFolder] as String;
    final folders = argResults.rest;
    final excludePath = argResults[FlagNames.exclude] as String;
    final reporterName = argResults[FlagNames.reporter] as String;
    final isMonorepo = argResults[FlagNames.isMonorepo] as bool;
    final noCongratulate = argResults[FlagNames.noCongratulate] as bool;

    final config = ConfigBuilder.getUnusedCodeConfigFromArgs(
      [excludePath],
      isMonorepo: isMonorepo,
    );

    final unusedCodeResult = await _analyzer.runCliAnalysis(
      folders,
      rootFolder,
      config,
      sdkPath: findSdkPath(),
    );

    await _analyzer
        .getReporter(
          name: reporterName,
          output: stdout,
        )
        ?.report(
          unusedCodeResult,
          additionalParams:
              UnusedCodeReportParams(congratulate: !noCongratulate),
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
        help: 'Treats all exported code as unused by default.',
      );
  }

  void _usesExitOption() {
    argParser
      ..addSeparator('')
      ..addFlag(
        FlagNames.fatalOnUnused,
        help: 'Treat find unused file as fatal.',
// TODO(dkrutrkikh): activate on next major version
//        defaultsTo: true,
      );
  }
}
