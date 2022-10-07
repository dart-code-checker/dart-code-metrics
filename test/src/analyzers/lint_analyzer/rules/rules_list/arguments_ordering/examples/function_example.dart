Person? createPerson(
        {required String name, required int age, String? surname}) =>
    null;

final goodPerson1 = createPerson(name: '', age: 42, surname: '');
final goodPerson2 = createPerson(name: '', age: 42);

final badPerson1 = createPerson(name: 42, surname: '', age: ''); // LINT
final badPerson2 = createPerson(surname: '', name: '', age: 42); // LINT
final badPerson3 = createPerson(surname: '', age: 42, name: ''); // LINT
final badPerson4 = createPerson(age: 42, surname: '', name: ''); // LINT
final badPerson5 = createPerson(age: 42, name: '', surname: ''); // LINT
final badPerson6 = createPerson(age: 42, name: ''); // LINT
