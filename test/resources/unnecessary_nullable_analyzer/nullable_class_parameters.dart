class NullableClassParameters {
  final String? value;

  const NullableClassParameters(this.value);
}

// LINT
class AlwaysUsedAsNonNullable {
  final String? anotherValue;

  const AlwaysUsedAsNonNullable(this.anotherValue);
}

class DefaultNonNullable {
  final String value;

  const DefaultNonNullable({this.value = '123'});
}

// LINT
class NamedNonNullable {
  final String? value;

  const NamedNonNullable({this.value});
}
