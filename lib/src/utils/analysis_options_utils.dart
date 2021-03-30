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

Object _merge(Object? defaults, Object overrides) {
  var o1 = defaults;
  var o2 = overrides;

  if (isIterableOfStrings(o1) && o2 is Map<String, Object>) {
    o1 = _iterableToMap(o1 as Iterable<Object>);
  } else if (o1 is Map<String, Object> && isIterableOfStrings(o2)) {
    o2 = _iterableToMap(o2 as Iterable<Object>);
  }

  if (o1 is Map<String, Object> && o2 is Map<String, Object>) {
    return mergeMaps(defaults: o1, overrides: o2);
  } else if (o1 is List<Object> && o2 is List<Object>) {
    return _mergeIterable(o1, o2);
  }

  return o2;
}

List<Object> _mergeIterable(
  Iterable<Object> defaults,
  Iterable<Object> overrides,
) =>
    List.unmodifiable(<Object>{...defaults, ...overrides});

Map<String, bool> _iterableToMap(Iterable<Object> list) =>
    Map.unmodifiable(Map<String, bool>.fromEntries(
      list.map((key) => MapEntry(key.toString(), true)),
    ));
