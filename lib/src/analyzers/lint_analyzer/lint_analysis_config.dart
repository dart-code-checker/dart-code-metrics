import 'package:glob/glob.dart';

import 'anti_patterns/models/obsolete_pattern.dart';
import 'metrics/models/metric.dart';
import 'rules/models/rule.dart';

class LintAnalysisConfig {
  final Iterable<Glob> globalExcludes;
  final Iterable<Rule> codeRules;
  final Iterable<ObsoletePattern> antiPatterns;
  final Iterable<Metric> classesMetrics;
  final Iterable<Metric> methodsMetrics;
  final Iterable<Glob> metricsExcludes;
  final Map<String, Object> metricsConfig;

  const LintAnalysisConfig(
    this.globalExcludes,
    this.codeRules,
    this.antiPatterns,
    this.classesMetrics,
    this.methodsMetrics,
    this.metricsExcludes,
    this.metricsConfig,
  );
}
