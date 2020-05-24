import 'package:meta/meta.dart';
import 'package:yaml/yaml.dart';

const String analysisOptionsFileName = 'analysis_options.yaml';

const _rootKey = 'dart_code_metrics';
const _rulesKey = 'rules';

/// Class representing options in `analysis_options.yaml`.

class AnalysisOptions {
  final Iterable<String> rulesNames;

  const AnalysisOptions({@required this.rulesNames});

  factory AnalysisOptions.from(String content) {
    var rules = <String>[];

    final node = loadYamlNode(content ?? '');
    if (node is YamlMap && node.nodes[_rootKey] is YamlMap) {
      final metricsOptions = node.nodes[_rootKey] as YamlMap;

      if (_isYamlListOfStrings(metricsOptions.nodes[_rulesKey])) {
        rules = List.unmodifiable(metricsOptions[_rulesKey] as Iterable);
      }
    }

    return AnalysisOptions(rulesNames: rules);
  }
}

bool _isYamlListOfStrings(YamlNode node) =>
    node != null &&
    node is YamlList &&
    node.nodes.every((node) => node.value is String);
