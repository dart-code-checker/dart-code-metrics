import 'dart:io';

import '../../analyzers/unused_files_analyzer/unused_files_analyzer.dart';
import '../../config_builder/config_builder.dart';
import '../../config_builder/models/analysis_options.dart';
import '../models/flag_names.dart';
import 'base_command.dart';

class CheckUnusedFilesCommand extends BaseCommand {
  static const _analyzer = UnusedFilesAnalyzer();

  @override
  String get name => 'check-unused-files';

  @override
  String get description => 'Check unused *.dart files.';

  @override
  String get invocation =>
      '${runner.executableName} $name [arguments] <directories>';

  CheckUnusedFilesCommand() {
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
    final folders = argResults.rest;
    final excludePath = argResults[FlagNames.exclude] as String;
    final reporterName = argResults[FlagNames.reporter] as String;

    final options = await analysisOptionsFromFilePath(rootFolder);
    final config = ConfigBuilder.getConfig(options);

    final unusedFilesConfig =
        ConfigBuilder.getUnusedFilesConfig(rootFolder, [excludePath]);
    final unusedFilesResult = await _analyzer.runCliAnalysis(
      folders,
      rootFolder,
      unusedFilesConfig,
      config.excludePatterns,
    );

    await _analyzer
        .getReporter(
          name: reporterName,
          output: stdout,
        )
        ?.report(unusedFilesResult);
  }

  void _addFlags() {
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
}
