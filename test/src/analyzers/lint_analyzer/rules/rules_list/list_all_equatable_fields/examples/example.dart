class SomePerson {
  const SomePerson(this.name);

  final String name;

  @override
  bool operator ==(Object other) =>
    identical(this, other) ||
    other is SomePerson &&
    runtimeType == other.runtimeType &&
    name == other.name;

  @override
  int get hashCode => name.hashCode;
}

class Person extends Equatable {
  const Person(this.name);

  final String name;

  @override
  List<Object> get props => [name];
}

class AnotherPerson extends Equatable {
  const AnotherPerson(this.name);

  final String name;

  final int age;

  @override
  List<Object> get props => [name]; // LINT
}

class Equatable {
  abstract List<Object> get props;
}
