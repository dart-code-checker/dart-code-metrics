extension ObjectExtensions on Object {
  T? as<T>([T? defaultValue]) => (this is T) ? this as T : defaultValue;
}
