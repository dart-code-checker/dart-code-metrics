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
    return [name]; // LINT
  }
}

class AndAnotherPerson extends Equatable {
  static final someProp = 'hello';

  const AndAnotherPerson(this.name);

  final String name;

  @override
  List<Object> get props => [name];
}

class SubPerson extends AndAnotherPerson {
  const SubPerson(this.value, String name) : super();

  final int value;

  @override
  List<Object> get props {
    return super.props..addAll([]); // LINT
  }
}

class EquatableDateTimeSubclass extends EquatableDateTime {
  final int century;

  EquatableDateTimeSubclass(
    this.century,
    int year, [
    int month = 1,
    int day = 1,
    int hour = 0,
    int minute = 0,
    int second = 0,
    int millisecond = 0,
    int microsecond = 0,
  ]) : super(year, month, day, hour, minute, second, millisecond, microsecond);

  @override
  List<Object> get props => super.props..addAll([]); // LINT
}

class EquatableDateTime extends DateTime with EquatableMixin {
  EquatableDateTime(
    int year, [
    int month = 1,
    int day = 1,
    int hour = 0,
    int minute = 0,
    int second = 0,
    int millisecond = 0,
    int microsecond = 0,
  ]) : super(year, month, day, hour, minute, second, millisecond, microsecond);

  @override
  List<Object> get props {
    return [
      year,
      month,
      day,
      hour,
      minute,
      second,
      millisecond,
      microsecond,
      // LINT
    ];
  }
}

class Equatable {
  List<Object> get props;
}

mixin EquatableMixin {
  List<Object?> get props;
}
