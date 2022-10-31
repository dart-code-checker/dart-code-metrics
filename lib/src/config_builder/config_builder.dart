import '../analyzers/lint_analyzer/anti_patterns/patterns_factory.dart';
import '../analyzers/lint_analyzer/lint_analysis_config.dart';
import '../analyzers/lint_analyzer/lint_config.dart';
import '../analyzers/lint_analyzer/metrics/metrics_factory.dart';
import '../analyzers/lint_analyzer/metrics/models/metric.dart';
import '../analyzers/lint_analyzer/models/entity_type.dart';
import '../analyzers/lint_analyzer/rules/rules_factory.dart';
import '../analyzers/unnecessary_nullable_analyzer/unnecessary_nullable_analysis_config.dart';
import '../analyzers/unnecessary_nullable_analyzer/unnecessary_nullable_config.dart';
import '../analyzers/unused_code_analyzer/unused_code_analysis_config.dart';
import '../analyzers/unused_code_analyzer/unused_code_config.dart';
import '../analyzers/unused_files_analyzer/unused_files_analysis_config.dart';
import '../analyzers/unused_files_analyzer/unused_files_config.dart';
import '../analyzers/unused_l10n_analyzer/unused_l10n_analysis_config.dart';
import '../analyzers/unused_l10n_analyzer/unused_l10n_config.dart';
import '../cli/models/parsed_arguments.dart';
import '../utils/exclude_utils.dart';
import 'models/analysis_options.dart';

/// Builder for creating a config for all available commands.
class ConfigBuilder {
  /// Creates a raw lint config from given [options].
  static LintConfig getLintConfigFromOptions(AnalysisOptions options) =>
      LintConfig.fromAnalysisOptions(options);

  /// Creates a raw lint config from given parsed [arguments].
  static LintConfig getLintConfigFromArgs(ParsedArguments arguments) =>
      LintConfig.fromArgs(arguments);

  /// Creates a lint config from given raw config.
  static LintAnalysisConfig getLintAnalysisConfig(
    LintConfig config,
    String rootFolder, {
    Iterable<Metric>? classMetrics,
    Iterable<Metric>? fileMetrics,
    Iterable<Metric>? functionMetrics,
  }) {
    final patterns = getPatternsById(config);
    final patternsDependencies = patterns
        .map((pattern) => pattern.dependentMetricIds)
        .expand((e) => e)
        .toSet();

    return LintAnalysisConfig(
      createAbsolutePatterns(config.excludePatterns, rootFolder),
      getRulesById(config.rules),
      createAbsolutePatterns(config.excludeForRulesPatterns, rootFolder),
      patterns,
      classMetrics ??
          getMetrics(
            config: config.metrics,
            patternsDependencies: patternsDependencies,
            measuredType: EntityType.classEntity,
          ),
      fileMetrics ??
          getMetrics(
            config: config.metrics,
            patternsDependencies: patternsDependencies,
            measuredType: EntityType.fileEntity,
          ),
      functionMetrics ??
          getMetrics(
            config: config.metrics,
            patternsDependencies: patternsDependencies,
            measuredType: EntityType.methodEntity,
          ),
      createAbsolutePatterns(config.excludeForMetricsPatterns, rootFolder),
      config.metrics,
      rootFolder,
      config.analysisOptionsPath,
    );
  }

  /// Creates a raw unused files config from given [excludePatterns].
  static UnusedFilesConfig getUnusedFilesConfigFromArgs(
    Iterable<String> excludePatterns, {
    required bool isMonorepo,
    required bool shouldPrintConfig,
  }) =>
      UnusedFilesConfig.fromArgs(
        excludePatterns,
        isMonorepo: isMonorepo,
        shouldPrintConfig: shouldPrintConfig,
      );

  /// Creates a raw unused files config from given [options].
  static UnusedFilesConfig getUnusedFilesConfigFromOption(
    AnalysisOptions options,
  ) =>
      UnusedFilesConfig.fromAnalysisOptions(options);

  /// Creates an unused files config from given raw [config].
  static UnusedFilesAnalysisConfig getUnusedFilesConfig(
    UnusedFilesConfig config,
    String rootPath,
  ) =>
      UnusedFilesAnalysisConfig(
        createAbsolutePatterns(config.excludePatterns, rootPath),
        isMonorepo: config.isMonorepo,
      );

  /// Creates a raw unused code config from given [excludePatterns].
  static UnusedCodeConfig getUnusedCodeConfigFromArgs(
    Iterable<String> excludePatterns, {
    required bool isMonorepo,
    required bool shouldPrintConfig,
  }) =>
      UnusedCodeConfig.fromArgs(
        excludePatterns,
        isMonorepo: isMonorepo,
        shouldPrintConfig: shouldPrintConfig,
      );

  /// Creates a raw unused code config from given [options].
  static UnusedCodeConfig getUnusedCodeConfigFromOption(
    AnalysisOptions options,
  ) =>
      UnusedCodeConfig.fromAnalysisOptions(options);

  /// Creates an unused code config from given raw [config].
  static UnusedCodeAnalysisConfig getUnusedCodeConfig(
    UnusedCodeConfig config,
    String rootPath,
  ) =>
      UnusedCodeAnalysisConfig(
        createAbsolutePatterns(config.excludePatterns, rootPath),
        createAbsolutePatterns(config.analyzerExcludePatterns, rootPath),
        isMonorepo: config.isMonorepo,
      );

  /// Creates a raw unused localization config from given [excludePatterns] and [classPattern].
  static UnusedL10nConfig getUnusedL10nConfigFromArgs(
    Iterable<String> excludePatterns,
    String classPattern, {
    required bool shouldPrintConfig,
  }) =>
      UnusedL10nConfig.fromArgs(
        excludePatterns,
        classPattern,
        shouldPrintConfig: shouldPrintConfig,
      );

  /// Creates a raw unused localization config from given [options].
  static UnusedL10nConfig getUnusedL10nConfigFromOption(
    AnalysisOptions options,
  ) =>
      UnusedL10nConfig.fromAnalysisOptions(options);

  /// Creates an unused localization config from given raw [config].
  static UnusedL10nAnalysisConfig getUnusedL10nConfig(
    UnusedL10nConfig config,
    String rootPath,
  ) =>
      UnusedL10nAnalysisConfig(
        createAbsolutePatterns(config.excludePatterns, rootPath),
        config.classPattern,
      );

  /// Creates a raw unnecessary nullable config from given [excludePatterns].
  static UnnecessaryNullableConfig getUnnecessaryNullableConfigFromArgs(
    Iterable<String> excludePatterns, {
    required bool isMonorepo,
    required bool shouldPrintConfig,
  }) =>
      UnnecessaryNullableConfig.fromArgs(
        excludePatterns,
        isMonorepo: isMonorepo,
        shouldPrintConfig: shouldPrintConfig,
      );

  /// Creates a raw unnecessary nullable config from given [options].
  static UnnecessaryNullableConfig getUnnecessaryNullableConfigFromOption(
    AnalysisOptions options,
  ) =>
      UnnecessaryNullableConfig.fromAnalysisOptions(options);

  /// Creates an unnecessary nullable config from given raw [config].
  static UnnecessaryNullableAnalysisConfig getUnnecessaryNullableConfig(
    UnnecessaryNullableConfig config,
    String rootPath,
  ) =>
      UnnecessaryNullableAnalysisConfig(
        createAbsolutePatterns(config.excludePatterns, rootPath),
        createAbsolutePatterns(config.analyzerExcludePatterns, rootPath),
        isMonorepo: config.isMonorepo,
      );
}
