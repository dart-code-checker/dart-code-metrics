mixin ValuesMapping<K, V> {
  V findValueByKey(Map<K, V> map, K key) => map[key];
}
