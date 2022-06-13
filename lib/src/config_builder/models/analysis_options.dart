import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context.dart';
import 'package:analyzer/dart/analysis/uri_converter.dart';
import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

import '../../utils/yaml_utils.dart';
import '../analysis_options_utils.dart';

const _analysisOptionsFileName = 'analysis_options.yaml';

/// Class representing dart analysis options.
class AnalysisOptions {
  final Map<String, Object> options;

  final String? _path;

  const AnalysisOptions(this._path, this.options);

  String? get folderPath {
    final finalPath = _path;

    return finalPath == null ? null : p.dirname(finalPath);
  }

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
      return Map.unmodifiable(Map<String, Map<String, Object>>.fromEntries(
        data.fold([], (previousValue, element) {
          if (element is String) {
            return [...previousValue, MapEntry(element, <String, Object>{})];
          }

          if (element is Map<String, Object>) {
            final hasSingleKey = element.keys.length == 1;
            final value = element.values.first;

            if (hasSingleKey && value is Map<String, Object> || value is bool) {
              final updatedValue = value is bool
                  ? <String, Object>{'enabled': value}
                  : value as Map<String, Object>;

              return [
                ...previousValue,
                MapEntry(element.keys.first, updatedValue),
              ];
            }
          }

          return previousValue;
        }),
      )..removeWhere((key, value) =>
          (value['enabled'] is bool && value['enabled'] == false)));
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

AnalysisOptions? analysisOptionsFromContext(
  AnalysisContext context,
) {
  final optionsFilePath = context.contextRoot.optionsFile?.path;

  return optionsFilePath == null
      ? null
      : analysisOptionsFromFile(File(optionsFilePath), context);
}

AnalysisOptions analysisOptionsFromFilePath(
  String path,
  AnalysisContext context,
) {
  final analysisOptionsFile = File(p.absolute(path, _analysisOptionsFileName));

  return analysisOptionsFromFile(analysisOptionsFile, context);
}

AnalysisOptions analysisOptionsFromFile(
  File? options,
  AnalysisContext context,
) =>
    options != null && options.existsSync()
        ? AnalysisOptions(
            options.path,
            _loadConfigFromYamlFile(
              options,
              context.currentSession.uriConverter,
            ),
          )
        : const AnalysisOptions(null, {});

Map<String, Object> _loadConfigFromYamlFile(
  File options,
  UriConverter converter,
) {
  try {
    final node = options.existsSync()
        ? loadYamlNode(options.readAsStringSync())
        : YamlMap();

    var optionsNode =
        node is YamlMap ? yamlMapToDartMap(node) : <String, Object>{};

    final includeNode = optionsNode['include'];
    if (includeNode is String) {
      final packageImport = includeNode.startsWith('package:');

      final resolvedUri = packageImport
          ? converter.uriToPath(Uri.parse(includeNode))
          : p.absolute(p.dirname(options.path), includeNode);

      if (resolvedUri != null) {
        final resolvedYamlMap =
            _loadConfigFromYamlFile(File(resolvedUri), converter);
        optionsNode =
            mergeMaps(defaults: resolvedYamlMap, overrides: optionsNode);
      }
    }

    return optionsNode;
  } on YamlException catch (e) {
    throw FormatException(e.message, e.span);
  }
}
