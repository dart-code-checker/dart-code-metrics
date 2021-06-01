/// Enum class for type of a function entity.
///
/// Used when reporting.
class FunctionType {
  /// The function entity representing a class constructor.
  static const constructor = FunctionType._('constructor');

  /// The function entity representing a class method.
  static const method = FunctionType._('method');

  /// The function entity representing a generic function.
  static const function = FunctionType._('function');

  /// The function entity representing a getter.
  static const getter = FunctionType._('getter');

  /// The function entity representing a setter.
  static const setter = FunctionType._('setter');

  final String _value;

  const FunctionType._(this._value);

  @override
  String toString() => _value;
}
