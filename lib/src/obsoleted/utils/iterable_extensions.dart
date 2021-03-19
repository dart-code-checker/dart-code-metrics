extension IterableExtensions<T> on Iterable<T> {
  T firstOrDefault([T defaultValue]) =>
      firstWhere((_) => true, orElse: () => defaultValue);

  T lastOrDefault([T defaultValue]) =>
      lastWhere((_) => true, orElse: () => defaultValue);
}
