import 'package:meta/meta.dart';
import 'package:yaml/yaml.dart';

import 'models/config.dart';

// Documantation about customizing static analysis located at https://dart.dev/guides/language/analysis-options

const String analysisOptionsFileName = 'analysis_options.yaml';

const _rootKey = 'dart_code_metrics';
const _metricsKey = 'metrics';
const _rulesKey = 'rules';

/// Class representing options in `analysis_options.yaml`.

class AnalysisOptions {
  final Config metricsConfig;
  final Iterable<String> rulesNames;

  const AnalysisOptions(
      {@required this.metricsConfig, @required this.rulesNames});

  factory AnalysisOptions.from(String content) {
    Config config;
    var rules = <String>[];

    final node = loadYamlNode(content ?? '');
    if (node is YamlMap && node.nodes[_rootKey] is YamlMap) {
      final metricsOptions = node.nodes[_rootKey] as YamlMap;

      if (_isYamlMapOfStringsAndIntegers(metricsOptions.nodes[_metricsKey])) {
        final configMap = metricsOptions[_metricsKey] as YamlMap;
        config = Config(
          cyclomaticComplexityWarningLevel:
              configMap['cyclomatic-complexity'] as int,
          linesOfCodeWarningLevel: configMap['lines-of-code'] as int,
          numberOfArgumentsWarningLevel:
              configMap['number-of-arguments'] as int,
        );
      }

      if (_isYamlListOfStrings(metricsOptions.nodes[_rulesKey])) {
        rules = List.unmodifiable(metricsOptions[_rulesKey] as Iterable);
      } else if (_isYamlMapOfStringsAndBooleans(
          metricsOptions.nodes[_rulesKey])) {
        final rulesMap = metricsOptions[_rulesKey] as YamlMap;
        rules = List.unmodifiable(
            rulesMap.keys.cast<String>().where((key) => rulesMap[key] as bool));
      }
    }

    return AnalysisOptions(metricsConfig: config, rulesNames: rules);
  }
}

bool _isYamlListOfStrings(YamlNode node) =>
    node != null &&
    node is YamlList &&
    node.nodes.every((node) => node.value is String);

bool _isYamlMapOfStringsAndBooleans(YamlNode node) =>
    node != null &&
    node is YamlMap &&
    node.nodes.values.every((val) => val is YamlScalar && val.value is bool);

bool _isYamlMapOfStringsAndIntegers(YamlNode node) =>
    node != null &&
    node is YamlMap &&
    node.nodes.values.every((val) => val is YamlScalar && val.value is int);
