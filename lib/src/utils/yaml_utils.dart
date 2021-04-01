import 'package:yaml/yaml.dart';

/// Convert yaml [list] to Dart [List].
List<Object> yamlListToDartList(YamlList list) =>
    List.unmodifiable(list.nodes.map<Object>(yamlNodeToDartObject));

/// Convert yaml [map] to Dart [Map].
Map<String, Object> yamlMapToDartMap(YamlMap map) =>
    Map.unmodifiable(Map<String, Object>.fromEntries(map.nodes.keys
        .whereType<YamlScalar>()
        .where((key) => key.value is String)
        .map((key) => MapEntry(
              key.value as String,
              yamlNodeToDartObject(map.nodes[key]),
            ))));

/// Convert yaml [node] to Dart [Object].
Object yamlNodeToDartObject(YamlNode? node) {
  var object = Object();

  if (node is YamlMap) {
    object = yamlMapToDartMap(node);
  } else if (node is YamlList) {
    object = yamlListToDartList(node);
  } else if (node is YamlScalar) {
    object = yamlScalarToDartObject(node);
  }

  return object;
}

/// Convert yaml [scalar] to Dart [Object].
Object yamlScalarToDartObject(YamlScalar scalar) => scalar.value as Object;
