import '../analyzers/lint_analyzer/anti_patterns/patterns_factory.dart';
import '../analyzers/lint_analyzer/lint_analysis_config.dart';
import '../analyzers/lint_analyzer/lint_config.dart';
import '../analyzers/lint_analyzer/metrics/metrics_factory.dart';
import '../analyzers/lint_analyzer/metrics/models/metric.dart';
import '../analyzers/lint_analyzer/models/entity_type.dart';
import '../analyzers/lint_analyzer/rules/rules_factory.dart';
import '../analyzers/unused_files_analyzer/unused_files_analysis_config.dart';
import '../analyzers/unused_files_analyzer/unused_files_config.dart';
import '../analyzers/unused_l10n_analyzer/unused_l10n_analysis_config.dart';
import '../analyzers/unused_l10n_analyzer/unused_l10n_config.dart';
import '../cli/models/parsed_arguments.dart';
import '../utils/exclude_utils.dart';
import 'models/analysis_options.dart';

class ConfigBuilder {
  static LintConfig getLintConfigFromOptions(AnalysisOptions options) =>
      LintConfig.fromAnalysisOptions(options);

  static LintConfig getLintConfigFromArgs(ParsedArguments arguments) =>
      LintConfig.fromArgs(arguments);

  static LintAnalysisConfig getLintAnalysisConfig(
    LintConfig config,
    String excludesRootFolder, {
    Iterable<Metric<num>>? classMetrics,
    Iterable<Metric<num>>? functionMetrics,
  }) =>
      LintAnalysisConfig(
        prepareExcludes(config.excludePatterns, excludesRootFolder),
        getRulesById(config.rules),
        prepareExcludes(config.excludeForRulesPatterns, excludesRootFolder),
        getPatternsById(config),
        classMetrics ??
            getMetrics(
              config: config.metrics,
              measuredType: EntityType.classEntity,
            ),
        functionMetrics ??
            getMetrics(
              config: config.metrics,
              measuredType: EntityType.methodEntity,
            ),
        prepareExcludes(config.excludeForMetricsPatterns, excludesRootFolder),
        config.metrics,
        excludesRootFolder,
      );

  static UnusedFilesConfig getUnusedFilesConfigFromArgs(
    Iterable<String> excludePatterns,
  ) =>
      UnusedFilesConfig.fromArgs(excludePatterns);

  static UnusedFilesConfig getUnusedFilesConfigFromOption(
    AnalysisOptions options,
  ) =>
      UnusedFilesConfig.fromAnalysisOptions(options);

  static UnusedFilesAnalysisConfig getUnusedFilesConfig(
    UnusedFilesConfig config,
    String rootPath,
  ) =>
      UnusedFilesAnalysisConfig(
        prepareExcludes(config.excludePatterns, rootPath),
        prepareExcludes(config.analyzerExcludePatterns, rootPath),
      );

  static UnusedL10nConfig getUnusedL10nConfigFromArgs(
    Iterable<String> excludePatterns,
    String classPattern,
  ) =>
      UnusedL10nConfig.fromArgs(excludePatterns, classPattern);

  static UnusedL10nConfig getUnusedL10nConfigFromOption(
    AnalysisOptions options,
  ) =>
      UnusedL10nConfig.fromAnalysisOptions(options);

  static UnusedL10nAnalysisConfig getUnusedL10nConfig(
    UnusedL10nConfig config,
    String rootPath,
  ) =>
      UnusedL10nAnalysisConfig(
        prepareExcludes(config.excludePatterns, rootPath),
        prepareExcludes(config.analyzerExcludePatterns, rootPath),
        config.classPattern,
      );
}
