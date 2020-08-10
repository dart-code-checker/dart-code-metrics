import 'package:yaml/yaml.dart';

bool isYamlListOfStrings(YamlNode node) =>
    node != null &&
    node is YamlList &&
    node.nodes.every((node) => node is YamlScalar && node.value is String);
