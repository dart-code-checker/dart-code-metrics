import 'dart:io';

import '../../analyzers/unused_localization_analyzer/unused_localization_analyzer.dart';
import '../../config_builder/config_builder.dart';
import '../models/flag_names.dart';
import 'base_command.dart';

class CheckUnusedL10nCommand extends BaseCommand {
  static const _analyzer = UnusedLocalizationAnalyzer();

  @override
  String get name => 'check-unused-l10n';

  @override
  String get description => 'Check unused localization in *.dart files.';

  @override
  String get invocation =>
      '${runner.executableName} $name [arguments] <directories>';

  CheckUnusedL10nCommand() {
    _addFlags();
  }

  @override
  void validateCommand() {
    validateRootFolderExist();
    validateTargetDirectories();
  }

  @override
  Future<void> runCommand() async {
    final rootFolder = argResults[FlagNames.rootFolder] as String;
    final classPattern = argResults[FlagNames.l10nClassPattern] as String;
    final excludePath = argResults[FlagNames.exclude] as String;
    final reporterName = argResults[FlagNames.reporter] as String;

    final folders = argResults.rest;

    final config = ConfigBuilder.getUnusedLocalizationConfigFromArgs(
      [excludePath],
      classPattern,
    );

    final unusedLocalizationResult = await _analyzer.runCliAnalysis(
      folders,
      rootFolder,
      config,
    );

    return _analyzer
        .getReporter(
          name: reporterName,
          output: stdout,
        )
        ?.report(unusedLocalizationResult);
  }

  void _addFlags() {
    _usesL10nClassPatternOption();
    _usesReporterOption();
    usesRootFolderOption();
    usesExcludeOption();
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
}
