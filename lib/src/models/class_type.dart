/// Enum class for type of a class entity.
///
/// Used when reporting.
class ClassType {
  /// The class entity representing a generic class.
  static const generic = ClassType._('class');

  /// The class entity representing a mixin.
  static const mixin = ClassType._('mixin');

  /// The class entity representing a extension.
  static const extension = ClassType._('extension');

  final String _value;

  const ClassType._(this._value);

  @override
  String toString() => _value;
}
