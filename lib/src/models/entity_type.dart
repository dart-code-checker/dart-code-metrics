/// Enum class for type of a type of entity
///
/// Used for classification of a metric
class EntityType {
  /// Entity represent a class, mixin or extension
  static const EntityType classEntity = EntityType._('class');

  /// Entity represent a class method or constructor, function, getter or setter
  static const EntityType methodEntity = EntityType._('method');

  /// A list containing all of the enum values that are defined.
  static const values = [classEntity, methodEntity];

  final String _value;

  const EntityType._(this._value);

  @override
  String toString() => _value;
}
