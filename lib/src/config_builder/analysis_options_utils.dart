/// Returns `true` if this [object] represents a iterable of strings.
bool isIterableOfStrings(Object? object) =>
    object is Iterable<Object> && object.every((node) => node is String);

/// Merges two maps [defaults] with an overriding [overrides] with simple
/// override semantics, suitable for merging two maps where one defines default
/// values that are added to (and possibly overridden) by an overriding collection.
Map<String, Object> mergeMaps({
  required Map<String, Object> defaults,
  required Map<String, Object> overrides,
}) {
  final merged = Map.of(defaults);

  for (final overrideKey in overrides.keys) {
    final mergedKey = merged.keys.firstWhere(
      (mergedKey) => mergedKey == overrideKey,
      orElse: () => overrideKey,
    );

    merged[mergedKey] = _merge(merged[mergedKey], overrides[overrideKey]!);
  }

  return Map.unmodifiable(merged);
}

bool _isCapableToTransformToMap(Object? object) =>
    object is Iterable<Object> &&
    object.every((node) => node is String || node is Map<String, Object>);

Object _merge(Object? defaults, Object overrides) {
  var obj1 = defaults;
  var obj2 = overrides;

  if (_isCapableToTransformToMap(obj1) && obj2 is Map<String, Object>) {
    obj1 = _iterableToMap(obj1 as Iterable<Object>);
  } else if (obj1 is Map<String, Object> && _isCapableToTransformToMap(obj2)) {
    obj2 = _iterableToMap(obj2 as Iterable<Object>);
  }

  if (obj1 is Map<String, Object> && obj2 is Map<String, Object>) {
    return mergeMaps(defaults: obj1, overrides: obj2);
  } else if (obj1 is List<Object> && obj2 is List<Object>) {
    return _mergeIterable(obj1, obj2);
  }

  return obj2;
}

List<Object> _mergeIterable(
  Iterable<Object> defaults,
  Iterable<Object> overrides,
) =>
    List.unmodifiable(<Object>{...defaults, ...overrides});

Map<String, Object> _iterableToMap(Iterable<Object> list) => Map.unmodifiable(
      <String, Object>{
        for (final key in list)
          if (key is Map<String, Object>) ...key else key.toString(): true,
      },
    );
