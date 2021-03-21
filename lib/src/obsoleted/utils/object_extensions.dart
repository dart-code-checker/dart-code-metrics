// ignore_for_file: public_member_api_docs
extension ObjectExtensions on Object {
  T as<T>([T defaultValue]) => (this is T) ? this as T : defaultValue;
}
