// ignore_for_file: public_member_api_docs, prefer-trailing-comma
import 'dart:io';
import 'dart:isolate';

import 'package:code_checker/checker.dart';
import 'package:yaml/yaml.dart';

Future<Map<String, Object>> loadConfigFromYamlFile(File options) async {
  try {
    final node = loadYamlNode(options?.readAsStringSync() ?? '');

    var optionsNode =
        node is YamlMap ? yamlMapToDartMap(node) : <String, Object>{};

    final includeNode = optionsNode['include'];
    if (includeNode is String) {
      final resolvedUri =
          await Isolate.resolvePackageUri(Uri.parse(includeNode));
      if (resolvedUri != null) {
        final resolvedYamlMap =
            await loadConfigFromYamlFile(File.fromUri(resolvedUri));
        optionsNode = _mergeMaps(resolvedYamlMap, optionsNode);
      }
    }

    return optionsNode;
  } on YamlException catch (e) {
    throw FormatException(e.message, e.span);
  }
}

Map<String, Object> _mergeMaps(
    Map<String, Object> defaults, Map<String, Object> overrides) {
  final merged = Map.of(defaults);

  for (final overrideKey in overrides.keys) {
    final mergedKey = merged.keys.firstWhere(
      (mergedKey) => mergedKey == overrideKey,
      orElse: () => overrideKey,
    );
    merged[mergedKey] = _merge(merged[mergedKey], overrides[overrideKey]);
  }

  return Map.unmodifiable(merged);
}

/// Merges two collections (of options, [defaults] with an overriding
/// [overrides]) with simple override semantics, suitable for merging two
/// collections where one defines default values that are added to (and
/// possibly overridden) by an overriding collection.
///
///   * lists are merged (without duplicates).
///   * lists can be promoted to simple maps when merged with maps of strings
///     to booleans (e.g., ['opt1', 'opt2'] becomes {'opt1': true, 'opt2': true}.
///   * maps are merged recursively.
///   * if map values cannot be merged, the overriding value is taken.
///
Object _merge(Object defaults, Object overrides) {
  var o1 = defaults;
  var o2 = overrides;

  if (_isListOfStrings(o1) && o2 is Map<String, Object>) {
    o1 = _listToMap(o1 as List<Object>);
  } else if (o1 is Map<String, Object> && _isListOfStrings(o2)) {
    o2 = _listToMap(o2 as List<Object>);
  }

  if (o1 is Map<String, Object> && o2 is Map<String, Object>) {
    return _mergeMaps(o1, o2);
  } else if (o1 is List<Object> && o2 is List<Object>) {
    return _mergeLists(o1, o2);
  }

  // Default to override, unless the overriding value is `null`.
  return o2 ?? o1;
}

/// Merge lists, avoiding duplicates.
List<Object> _mergeLists(List<Object> defaults, List<Object> overrides) =>
    List.unmodifiable(<Object>{...defaults, ...overrides});

bool _isListOfStrings(Object object) =>
    object is List<Object> && object.every((node) => node is String);

Map<String, bool> _listToMap(List<Object> list) =>
    Map.unmodifiable(Map<String, bool>.fromEntries(
        list.map((key) => MapEntry(key.toString(), true))));
