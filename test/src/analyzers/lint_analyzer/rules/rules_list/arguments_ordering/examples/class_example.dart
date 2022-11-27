class Person {
  Person({
    required this.name,
    required this.age,
    this.surname,
  });

  final String name;
  final int age;
  final String? surname;
}

final goodPerson1 = Person(name: '', age: 42, surname: '');
final goodPerson2 = Person(name: '', age: 42);

final badPerson1 = Person(name: 42, surname: '', age: ''); // LINT
final badPerson2 = Person(surname: '', name: '', age: 42); // LINT
final badPerson3 = Person(surname: '', age: 42, name: ''); // LINT
final badPerson4 = Person(age: 42, surname: '', name: ''); // LINT
final badPerson5 = Person(age: 42, name: '', surname: ''); // LINT
final badPerson6 = Person(age: 42, name: ''); // LINT
