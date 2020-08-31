import 'package:dart_code_metrics/src/rules/base_rule.dart';
import 'package:glob/glob.dart';
import 'package:meta/meta.dart';

import '../models/config.dart';

@immutable
class AnalyzerPluginConfig {
  final Config metricsConfigs;
  final Iterable<Glob> globalExcludes;
  final Iterable<Glob> metricsExcludes;
  final Iterable<BaseRule> checkingCodeRules;

  const AnalyzerPluginConfig(this.metricsConfigs, this.globalExcludes,
      this.metricsExcludes, this.checkingCodeRules);
}
