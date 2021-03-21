/// Enum class for type of a function entity.
///
/// Used when reporting.
class FunctionType {
  /// The class entity representing a class constructor.
  static const constructor = FunctionType._('constructor');

  /// The class entity representing a class method.
  static const method = FunctionType._('method');

  /// The class entity representing a function.
  static const function = FunctionType._('function');

  /// The class entity representing a getter.
  static const getter = FunctionType._('getter');

  /// The class entity representing a setter.
  static const setter = FunctionType._('setter');

  final String _value;

  const FunctionType._(this._value);

  @override
  String toString() => _value;
}
