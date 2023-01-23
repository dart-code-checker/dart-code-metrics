/// Enum class for type of a type of entity.
///
/// Used for classification of a metric.
class EntityType {
  /// The entity representing a class, mixin or extension.
  static const classEntity = EntityType._('class');

  /// The entity representing a whole file.
  static const fileEntity = EntityType._('file');

  /// The entity representing a class method or constructor, function, getter or setter.
  static const methodEntity = EntityType._('method');

  final String _value;

  const EntityType._(this._value);

  @override
  String toString() => _value;
}
