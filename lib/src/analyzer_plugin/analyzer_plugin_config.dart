import 'package:glob/glob.dart';
import 'package:meta/meta.dart';

import '../analyzers/lint_analyzer/anti_patterns/models/obsolete_pattern.dart';
import '../analyzers/lint_analyzer/metrics/models/metric.dart';
import '../analyzers/lint_analyzer/rules/models/rule.dart';

@immutable
class AnalyzerPluginConfig {
  final Iterable<Glob> globalExcludes;
  final Iterable<Rule> codeRules;
  final Iterable<Metric> methodsMetrics;
  final Iterable<Glob> metricsExcludes;
  final Iterable<ObsoletePattern> antiPatterns;
  final Map<String, Object> metricsConfig;

  const AnalyzerPluginConfig(
    this.globalExcludes,
    this.codeRules,
    this.methodsMetrics,
    this.metricsExcludes,
    this.antiPatterns,
    this.metricsConfig,
  );
}
