import 'package:glob/glob.dart';

import 'anti_patterns/models/pattern.dart';
import 'metrics/models/metric.dart';
import 'rules/models/rule.dart';

/// Represents converted lint config which contains parsed entities.

class LintAnalysisConfig {
  final Iterable<Glob> globalExcludes;
  final Iterable<Rule> codeRules;
  final Iterable<Glob> rulesExcludes;
  final Iterable<Pattern> antiPatterns;
  final Iterable<Metric> classesMetrics;
  final Iterable<Metric> methodsMetrics;
  final Iterable<Metric> fileMetrics;
  final Iterable<Glob> metricsExcludes;
  final Map<String, Object> metricsConfig;
  final String rootFolder;
  final String? analysisOptionsPath;

  const LintAnalysisConfig(
    this.globalExcludes,
    this.codeRules,
    this.rulesExcludes,
    this.antiPatterns,
    this.classesMetrics,
    this.fileMetrics,
    this.methodsMetrics,
    this.metricsExcludes,
    this.metricsConfig,
    this.rootFolder,
    this.analysisOptionsPath,
  );

  Map<String, Object?> toJson() => {
        'rules': codeRules.map((rule) => rule.toJson()).toList(),
        'rules-excludes': rulesExcludes.map((glob) => glob.pattern).toList(),
        'anti-patterns':
            antiPatterns.map((pattern) => pattern.toJson()).toList(),
        'metrics-config': metricsConfig,
        'class-metrics': classesMetrics.map((metric) => metric.id).toList(),
        'method-metrics': methodsMetrics.map((metric) => metric.id).toList(),
        'file-metrics': fileMetrics.map((metric) => metric.id).toList(),
        'metrics-excludes':
            metricsExcludes.map((glob) => glob.pattern).toList(),
        'analysis-options-path': analysisOptionsPath,
      };
}
