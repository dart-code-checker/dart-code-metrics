import 'dart:io';

import 'package:path/path.dart';

import '../analyzers/lint_analyzer/lint_analyzer.dart';
import '../analyzers/lint_analyzer/reporters/reporter_factory.dart';
import '../analyzers/lint_analyzer/reporters/utility_selector.dart';
import '../config_builder/models/analysis_options.dart';
import '../config_builder/models/config.dart';
import 'arguments_builder/arguments_builder.dart';

class CliRunner {
  static Future<void> runAnalysis(List<String> args) async {
    final parsedArgs = ArgumentsBuilder.getArguments(args);

    if (parsedArgs != null) {
      final analysisOptionsFile =
          File(absolute(parsedArgs.rootFolder, analysisOptionsFileName));

      final options = await analysisOptionsFromFile(analysisOptionsFile);
      final config = Config.fromAnalysisOptions(options)
          .merge(Config.fromArgs(parsedArgs));

      final lintAnalyserResult = await const LintAnalyzer().runCliAnalysis(
        parsedArgs.folders,
        parsedArgs.rootFolder,
        config,
      );

      await reporter(
        name: parsedArgs.reporterName,
        output: stdout,
        config: config,
        reportFolder: parsedArgs.reportFolder,
      )?.report(lintAnalyserResult);

      if (parsedArgs.maximumAllowedLevel != null &&
          UtilitySelector.maxViolationLevel(lintAnalyserResult) >=
              parsedArgs.maximumAllowedLevel!) {
        exit(2);
      }
    }
  }
}
