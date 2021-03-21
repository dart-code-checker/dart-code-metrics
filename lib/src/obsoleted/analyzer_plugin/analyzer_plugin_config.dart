// ignore_for_file: public_member_api_docs
import 'package:code_checker/rules.dart';
import 'package:glob/glob.dart';
import 'package:meta/meta.dart';

import '../anti_patterns/base_pattern.dart';
import '../config/config.dart';

@immutable
class AnalyzerPluginConfig {
  final Config metricsConfigs;
  final Iterable<Glob> globalExcludes;
  final Iterable<Glob> metricsExcludes;
  final Iterable<BasePattern> checkingAntiPatterns;
  final Iterable<Rule> checkingCodeRules;

  const AnalyzerPluginConfig(
    this.metricsConfigs,
    this.globalExcludes,
    this.metricsExcludes,
    this.checkingAntiPatterns,
    this.checkingCodeRules,
  );
}
