import 'dart:io';

import '../analyzers/lint_analyzer/lint_analyzer.dart';
import '../analyzers/lint_analyzer/reporters/utility_selector.dart';
import '../config_builder/config_builder.dart';
import '../config_builder/models/analysis_options.dart';
import 'arguments_builder/arguments_builder.dart';

class CliRunner {
  static const _analyzer = LintAnalyzer();

  static Future<void> runAnalysis(List<String> args) async {
    final parsedArgs = ArgumentsBuilder.getArguments(args);

    if (parsedArgs != null) {
      final options = await analysisOptionsFromFilePath(parsedArgs.rootFolder);
      final config = ConfigBuilder.getConfig(options, parsedArgs);
      final lintConfig =
          ConfigBuilder.getLintConfig(config, parsedArgs.rootFolder);

      final lintAnalyserResult = await _analyzer.runCliAnalysis(
        parsedArgs.folders,
        parsedArgs.rootFolder,
        lintConfig,
      );

      await _analyzer
          .getReporter(
            name: parsedArgs.reporterName,
            output: stdout,
            config: config,
            reportFolder: parsedArgs.reportFolder,
          )
          ?.report(lintAnalyserResult);

      if (parsedArgs.maximumAllowedLevel != null &&
          UtilitySelector.maxViolationLevel(lintAnalyserResult) >=
              parsedArgs.maximumAllowedLevel!) {
        exit(2);
      }
    }
  }
}
