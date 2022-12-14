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
  const AnotherPerson(this.name, this.age);

  final String name;

  final int age;

  @override
  List<Object> get props => [name]; // LINT
}

class AndAnotherPerson extends Equatable {
  const AndAnotherPerson(this.name, this.age, this.address);

  final String name;

  final int age;

  final String address;

  @override
  List<Object> get props {
    return [name];  // LINT
  }
}

class AndAnotherPerson extends Equatable {
  static final someProp = 'hello';

  const AndAnotherPerson(this.name);

  final String name;

  @override
  List<Object> get props => [name];
}

class Equatable {
  abstract List<Object> get props;
}
