import 'package:glob/glob.dart';
import 'package:meta/meta.dart';

import '../../metrics/metric.dart';
import '../../rules/rule.dart';
import '../anti_patterns/obsolete_pattern.dart';

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
