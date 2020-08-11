import 'package:yaml/yaml.dart';

List<Object> yamlListToDartList(YamlList map) => List.unmodifiable(
    List<Object>.from(map.nodes.map<Object>(yamlNodeToDartObject)));

Map<String, Object> yamlMapToDartMap(YamlMap map) =>
    Map.unmodifiable(Map<String, Object>.fromEntries(map.nodes.keys
        .whereType<YamlScalar>()
        .where((key) => key.value is String)
        .map((key) => MapEntry(
            key.value as String, yamlNodeToDartObject(map.nodes[key])))));

Object yamlScalarToDartObject(YamlScalar scalar) => scalar.value as Object;

Object yamlNodeToDartObject(YamlNode node) {
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
