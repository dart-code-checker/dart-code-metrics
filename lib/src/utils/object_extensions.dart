extension ObjectExtensions on Object {
  T as<T>([T defaultValue]) {
    if (this is T) {
      return this as T;
    } else {
      return defaultValue;
    }
  }
}
