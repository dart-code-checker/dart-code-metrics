import 'dart:io';
import 'dart:isolate';

import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

import '../../utils/yaml_utils.dart';
import '../analysis_options_utils.dart';

const _analysisOptionsFileName = 'analysis_options.yaml';

/// Class representing dart analysis options
@immutable
class AnalysisOptions {
  final Map<String, Object> options;

  const AnalysisOptions(this.options);

  Iterable<String> readIterableOfString(Iterable<String> pathSegments) {
    Object? data = options;

    for (final key in pathSegments) {
      if (data is Map<String, Object> && data.containsKey(key)) {
        data = data[key];
      } else {
        return [];
      }
    }

    return isIterableOfStrings(data) ? (data as Iterable).cast<String>() : [];
  }

  Map<String, Object> readMap(Iterable<String> pathSegments) {
    Object? data = options;

    for (final key in pathSegments) {
      if (data is Map<String, Object?> && data.containsKey(key)) {
        data = data[key];
      } else {
        return {};
      }
    }

    return data is Map<String, Object> ? data : {};
  }

  Map<String, Map<String, Object>> readMapOfMap(Iterable<String> pathSegments) {
    Object? data = options;

    for (final key in pathSegments) {
      if (data is Map<String, Object?> && data.containsKey(key)) {
        data = data[key];
      } else {
        return {};
      }
    }

    if (data is Iterable<Object>) {
      return Map.unmodifiable(Map<String, Map<String, Object>>.fromEntries([
        ...data.whereType<String>().map((node) => MapEntry(node, {})),
        ...data
            .whereType<Map<String, Object>>()
            .where((node) =>
                node.keys.length == 1 &&
                node.values.first is Map<String, Object>)
            .map((node) => MapEntry(
                  node.keys.first,
                  node.values.first as Map<String, Object>,
                )),
      ]));
    } else if (data is Map<String, Object>) {
      final rulesNode = data;

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

    return {};
  }
}

Future<AnalysisOptions> analysisOptionsFromFilePath(String path) {
  final analysisOptionsFile = File(p.absolute(path, _analysisOptionsFileName));

  return analysisOptionsFromFile(analysisOptionsFile);
}

Future<AnalysisOptions> analysisOptionsFromFile(File? options) async =>
    options != null && options.existsSync()
        ? AnalysisOptions(await _loadConfigFromYamlFile(options))
        : const AnalysisOptions({});

Future<Map<String, Object>> _loadConfigFromYamlFile(File options) async {
  try {
    final node = options.existsSync()
        ? loadYamlNode(options.readAsStringSync())
        : YamlMap();

    var optionsNode =
        node is YamlMap ? yamlMapToDartMap(node) : <String, Object>{};

    final includeNode = optionsNode['include'];
    if (includeNode is String) {
      final resolvedUri = includeNode.startsWith('package:')
          ? await Isolate.resolvePackageUri(Uri.parse(includeNode))
          : Uri.file(p.absolute(p.dirname(options.path), includeNode));
      if (resolvedUri != null) {
        final resolvedYamlMap =
            await _loadConfigFromYamlFile(File.fromUri(resolvedUri));
        optionsNode =
            mergeMaps(defaults: resolvedYamlMap, overrides: optionsNode);
      }
    }

    return optionsNode;
  } on YamlException catch (e) {
    throw FormatException(e.message, e.span);
  }
}
