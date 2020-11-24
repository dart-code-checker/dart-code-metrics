import 'dart:io';

import 'package:meta/meta.dart';

import '../utils/object_extensions.dart';
import '../utils/yaml_utils.dart';
import 'config.dart';

// Documentation about customizing static analysis located at https://dart.dev/guides/language/analysis-options

const String analysisOptionsFileName = 'analysis_options.yaml';

const _rootKey = 'dart_code_metrics';
const _metricsKey = 'metrics';
const _metricsExcludeKey = 'metrics-exclude';
const _rulesKey = 'rules';
const _antiPatternsKey = 'anti-patterns';

const _analyzerKey = 'analyzer';
const _excludeKey = 'exclude';

/// Class representing options in `analysis_options.yaml`.

class AnalysisOptions {
  final Iterable<String> excludePatterns;
  final Config metricsConfig;
  final Iterable<String> metricsExcludePatterns;
  final Map<String, Map<String, Object>> rules;
  final Map<String, Map<String, Object>> antiPatterns;

  const AnalysisOptions({
    @required this.excludePatterns,
    @required this.metricsConfig,
    @required this.metricsExcludePatterns,
    @required this.rules,
    @required this.antiPatterns,
  });

  factory AnalysisOptions.fromMap(Map<String, Object> map) {
    final configMap = map ?? {};

    return AnalysisOptions(
      excludePatterns: _readGlobalExludePatterns(configMap),
      metricsConfig: _readMetricsConfig(configMap),
      metricsExcludePatterns: _readMetricsExcludePatterns(configMap),
      rules: _readRules(configMap, _rulesKey),
      antiPatterns: _readRules(configMap, _antiPatternsKey),
    );
  }
}

Iterable<String> _readGlobalExludePatterns(Map<String, Object> configMap) {
  final analyzerOptions = configMap[_analyzerKey];
  if (analyzerOptions is Map<String, Object>) {
    final excludeList = analyzerOptions[_excludeKey];
    if (excludeList is Iterable<Object> &&
        excludeList.every((element) => element is String)) {
      return List<String>.unmodifiable(excludeList);
    }
  }

  return [];
}

Config _readMetricsConfig(Map<String, Object> configMap) {
  final metricsOptions = configMap[_rootKey];
  if (metricsOptions is Map<String, Object>) {
    final configMap = metricsOptions[_metricsKey];
    if (configMap is Map<String, Object>) {
      return Config(
        cyclomaticComplexityWarningLevel: configMap[cyclomaticComplexityKey]
            .as<int>(cyclomaticComplexityDefaultWarningLevel),
        linesOfExecutableCodeWarningLevel: configMap[linesOfExecutableCodeKey]
            .as<int>(linesOfExecutableCodeDefaultWarningLevel),
        numberOfArgumentsWarningLevel: configMap[numberOfArgumentsKey]
            .as<int>(numberOfArgumentsDefaultWarningLevel),
        numberOfMethodsWarningLevel: configMap[numberOfMethodsKey]
            .as<int>(numberOfMethodsDefaultWarningLevel),
        maximumNestingWarningLevel: configMap['maximum-nesting']
            .as<int>(maximumNestingDefaultWarningLevel),
      );
    }
  }

  return const Config();
}

Iterable<String> _readMetricsExcludePatterns(Map<String, Object> configMap) {
  final metricsOptions = configMap[_rootKey];
  if (metricsOptions is Map<String, Object>) {
    final excludeList = metricsOptions[_metricsExcludeKey];
    if (excludeList is Iterable<Object> &&
        excludeList.every((element) => element is String)) {
      return List<String>.unmodifiable(excludeList);
    }
  }

  return [];
}

Map<String, Map<String, Object>> _readRules(
    Map<String, Object> configMap, String rulesKey) {
  final metricsOptions = configMap[_rootKey];
  if (metricsOptions is Map<String, Object>) {
    final rulesNode = metricsOptions[rulesKey];
    if (rulesNode is Iterable<Object>) {
      return Map.unmodifiable(Map<String, Map<String, Object>>.fromEntries([
        ...rulesNode.whereType<String>().map((node) => MapEntry(node, {})),
        ...rulesNode
            .whereType<Map<String, Object>>()
            .where((node) =>
                node.keys.length == 1 &&
                node.values.first is Map<String, Object>)
            .map((node) => MapEntry(
                node.keys.first, node.values.first as Map<String, Object>)),
      ]));
    } else if (rulesNode is Map<String, Object>) {
      return Map.unmodifiable(Map<String, Map<String, Object>>.fromEntries([
        ...rulesNode.entries
            .where((entry) => entry.value is bool && entry.value as bool)
            .map((entry) => MapEntry(entry.key, {})),
        ...rulesNode.keys.where((key) {
          final node = rulesNode[key];

          return node is Map<String, Object>;
        }).map((key) => MapEntry(key, rulesNode[key] as Map<String, Object>)),
      ]));
    }
  }

  return {};
}

/// Parse and construct options from YAML file.

Future<AnalysisOptions> analysisOptionsFromFile(File options) async =>
    AnalysisOptions.fromMap(await loadConfigFromYamlFile(options));
