import 'dart:io';

import 'package:meta/meta.dart';
import 'package:yaml/yaml.dart';

import 'models/config.dart';
import 'utils/object_extensions.dart';
import 'utils/yaml_utils.dart';

// Documantation about customizing static analysis located at https://dart.dev/guides/language/analysis-options

const String analysisOptionsFileName = 'analysis_options.yaml';

const _rootKey = 'dart_code_metrics';
const _metricsKey = 'metrics';
const _metricsExcludeKey = 'metrics-exclude';
const _rulesKey = 'rules';

const _analyzerKey = 'analyzer';
const _excludeKey = 'exclude';

/// Class representing options in `analysis_options.yaml`.

class AnalysisOptions {
  final Iterable<String> excludePatterns;
  final Config metricsConfig;
  final Iterable<String> metricsExcludePatterns;
  final Map<String, Map<String, Object>> rules;

  const AnalysisOptions({
    @required this.excludePatterns,
    @required this.metricsConfig,
    @required this.metricsExcludePatterns,
    @required this.rules,
  });

  @Deprecated('Use fromMap')
  factory AnalysisOptions.from(String content) {
    try {
      final node = loadYamlNode(content ?? '');

      return AnalysisOptions.fromMap(
          node is YamlMap ? yamlMapToDartMap(node) : {});
    } on YamlException catch (e) {
      throw FormatException(e.message, e.span);
    }
  }

  factory AnalysisOptions.fromMap(Map<String, Object> map) {
    final configMap = map ?? {};

    return AnalysisOptions(
        excludePatterns: _readGlobalExludePatterns(configMap),
        metricsConfig: _readMetricsConfig(configMap),
        metricsExcludePatterns: _readMetricsExcludePatterns(configMap),
        rules: _readRules(configMap));
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
        cyclomaticComplexityWarningLevel:
            configMap['cyclomatic-complexity'].as<int>(),
        linesOfCodeWarningLevel: configMap['lines-of-code'].as<int>(),
        numberOfArgumentsWarningLevel:
            configMap['number-of-arguments'].as<int>(),
        numberOfMethodsWarningLevel: configMap['number-of-methods'].as<int>(),
      );
    }
  }

  return null;
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

Map<String, Map<String, Object>> _readRules(Map<String, Object> configMap) {
  final metricsOptions = configMap[_rootKey];
  if (metricsOptions is Map<String, Object>) {
    final rulesNode = metricsOptions[_rulesKey];
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

Future<AnalysisOptions> analysisOptionsFromFile(File options) async =>
    AnalysisOptions.fromMap(await loadConfigFromYamlFile(options));
