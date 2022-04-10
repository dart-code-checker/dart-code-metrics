// ignore_for_file: public_member_api_docs

import 'dart:io';

import '../../analyzers/unused_l10n_analyzer/reporters/unused_l10n_report_params.dart';
import '../../analyzers/unused_l10n_analyzer/unused_l10n_analyzer.dart';
import '../../config_builder/config_builder.dart';
import '../models/flag_names.dart';
import 'base_command.dart';

class CheckUnusedL10nCommand extends BaseCommand {
  static const _analyzer = UnusedL10nAnalyzer();

  @override
  String get name => 'check-unused-l10n';

  @override
  String get description => 'Check unused localization in *.dart files.';

  @override
  String get invocation =>
      '${runner?.executableName} $name [arguments] <directories>';

  CheckUnusedL10nCommand() {
    _addFlags();
  }

  @override
  Future<void> runCommand() async {
    final rootFolder = argResults[FlagNames.rootFolder] as String;
    final classPattern = argResults[FlagNames.l10nClassPattern] as String;
    final excludePath = argResults[FlagNames.exclude] as String;
    final reporterName = argResults[FlagNames.reporter] as String;

    final noCongratulate = argResults[FlagNames.noCongratulate] as bool;

    final folders = argResults.rest;

    final config = ConfigBuilder.getUnusedL10nConfigFromArgs(
      [excludePath],
      classPattern,
    );

    final unusedL10nResult = await _analyzer.runCliAnalysis(
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
          unusedL10nResult,
          additionalParams:
              UnusedL10NReportParams(congratulate: !noCongratulate),
        );

    if (unusedL10nResult.isNotEmpty &&
        (argResults[FlagNames.fatalOnUnused] as bool)) {
      exit(1);
    }
  }

  void _addFlags() {
    _usesL10nClassPatternOption();
    _usesReporterOption();
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
          FlagNames.jsonReporter,
        ],
        defaultsTo: FlagNames.consoleReporter,
      );
  }

  void _usesL10nClassPatternOption() {
    argParser
      ..addSeparator('')
      ..addOption(
        FlagNames.l10nClassPattern,
        abbr: 'p',
        help: 'The pattern to detect classes providing localization',
        valueHelp: r'I18n$',
        defaultsTo: r'I18n$',
      );
  }

  void _usesExitOption() {
    argParser
      ..addSeparator('')
      ..addFlag(
        FlagNames.fatalOnUnused,
        help: 'Treat find unused l10n as fatal.',
// TODO(dkrutrkikh): activate on next major version
//        defaultsTo: true,
      );
  }
}
