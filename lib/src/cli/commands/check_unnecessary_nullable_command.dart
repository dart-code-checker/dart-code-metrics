// ignore_for_file: public_member_api_docs

import 'dart:io';

import '../../analyzers/unnecessary_nullable_analyzer/reporters/unnecessary_nullable_report_params.dart';
import '../../analyzers/unnecessary_nullable_analyzer/unnecessary_nullable_analyzer.dart';
import '../../config_builder/config_builder.dart';
import '../models/flag_names.dart';
import 'base_command.dart';

class CheckUnnecessaryNullableCommand extends BaseCommand {
  static const _analyzer = UnnecessaryNullableAnalyzer();

  @override
  String get name => 'check-unnecessary-nullable';

  @override
  String get description =>
      'Check unnecessary nullable parameters in functions, methods, constructors.';

  @override
  String get invocation =>
      '${runner?.executableName} $name [arguments] <directories>';

  CheckUnnecessaryNullableCommand() {
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

    final config = ConfigBuilder.getUnnecessaryNullableConfigFromArgs(
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
              UnnecessaryNullableReportParams(congratulate: !noCongratulate),
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
            'Treats all exported code with parameters as non-nullable by default.',
      );
  }

  void _usesExitOption() {
    argParser
      ..addSeparator('')
      ..addFlag(
        FlagNames.fatalOnFound,
        help: 'Treat found unnecessary nullable parameters as fatal.',
// TODO(dkrutrkikh): activate on next major version
//        defaultsTo: true,
      );
  }
}
