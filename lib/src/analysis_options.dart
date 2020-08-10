import 'package:meta/meta.dart';
import 'package:yaml/yaml.dart';

import 'models/config.dart';
import 'utils/yaml_utls.dart';

// Documantation about customizing static analysis located at https://dart.dev/guides/language/analysis-options

const String analysisOptionsFileName = 'analysis_options.yaml';

const _rootKey = 'dart_code_metrics';
const _metricsKey = 'metrics';
const _metricsExcludeKey = 'metrics-exclude';
const _rulesKey = 'rules';

/// Class representing options in `analysis_options.yaml`.

class AnalysisOptions {
  final Config metricsConfig;
  final Iterable<String> metricsExcludePatterns;
  final Map<String, Map<String, Object>> rules;

  const AnalysisOptions(
      {@required this.metricsConfig,
      @required this.metricsExcludePatterns,
      @required this.rules});

  factory AnalysisOptions.from(String content) {
    try {
      final node = loadYamlNode(content ?? '');

      return AnalysisOptions.fromYamlMap(node is YamlMap ? node : YamlMap());
    } on YamlException catch (e) {
      throw FormatException(e.message, e.span);
    }
  }

  factory AnalysisOptions.fromYamlMap(YamlMap node) {
    Config metricsConfig;
    var metricsExcludePatterns = <String>[];
    var rules = <String, Map<String, Object>>{};

    if (node.nodes[_rootKey] is YamlMap) {
      final metricsOptions = node.nodes[_rootKey] as YamlMap;

      if (_isYamlMapOfStringsAndIntegers(metricsOptions.nodes[_metricsKey])) {
        final configMap = metricsOptions[_metricsKey] as YamlMap;
        metricsConfig = Config(
          cyclomaticComplexityWarningLevel:
              configMap['cyclomatic-complexity'] as int,
          linesOfCodeWarningLevel: configMap['lines-of-code'] as int,
          numberOfArgumentsWarningLevel:
              configMap['number-of-arguments'] as int,
          numberOfMethodsWarningLevel: configMap['number-of-methods'] as int,
        );
      }

      if (isYamlListOfStrings(metricsOptions.nodes[_metricsExcludeKey])) {
        metricsExcludePatterns =
            List.unmodifiable(metricsOptions[_metricsExcludeKey] as Iterable);
      }

      final rulesNode = metricsOptions.nodes[_rulesKey];
      if (rulesNode != null && rulesNode is YamlList) {
        rules = Map.unmodifiable(Map<String, Map<String, Object>>.fromEntries([
          ...rulesNode.nodes
              .whereType<YamlScalar>()
              .map((node) => MapEntry(node.value as String, {})),
          ...rulesNode.nodes
              .whereType<YamlMap>()
              .where((node) =>
                  node.keys.length == 1 && node.values.first is YamlMap)
              .map((node) => MapEntry(node.keys.cast<String>().first,
                  (node.values.first as Map).cast<String, Object>())),
        ]));
      } else if (rulesNode != null && rulesNode is YamlMap) {
        rules = Map.unmodifiable(Map<String, Map<String, Object>>.fromEntries([
          ...rulesNode.keys.cast<String>().where((key) {
            final node = rulesNode.nodes[key];

            return (node is YamlScalar && node.value is bool) &&
                (node.value as bool);
          }).map((key) => MapEntry(key, {})),
          ...rulesNode.keys
              .cast<String>()
              .where((key) => rulesNode.nodes[key] is YamlMap)
              .map((key) => MapEntry(key,
                  (rulesNode.nodes[key].value as Map).cast<String, Object>())),
        ]));
      }
    }

    return AnalysisOptions(
        metricsConfig: metricsConfig,
        metricsExcludePatterns: metricsExcludePatterns,
        rules: rules);
  }
}

bool _isYamlMapOfStringsAndIntegers(YamlNode node) =>
    node != null &&
    node is YamlMap &&
    node.nodes.values.every((val) => val is YamlScalar && val.value is int);
