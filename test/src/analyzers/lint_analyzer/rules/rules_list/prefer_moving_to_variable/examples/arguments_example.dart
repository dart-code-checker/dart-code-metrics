void main() {
  final someValue = 'value';

  methodWithArguments('hello');
  methodWithArguments('hello', 'world');

  methodWithArguments('world'); // LINT
  methodWithArguments('world'); // LINT

  methodWithArguments(someValue); // LINT
  methodWithArguments(someValue); // LINT

  final someOtherValue = 'otherValue';
  methodWithArguments(someOtherValue);
  methodWithArguments(someValue); // LINT

  methodWithNamedArguments(age: 1);
  methodWithNamedArguments(age: 1, firstName: '');

  methodWithNamedArguments(firstName: 'hello'); // LINT
  methodWithNamedArguments(firstName: 'hello'); // LINT

  methodWithNamedArguments(lastName: 'last'); // LINT

  if (true) {
    methodWithNamedArguments(lastName: 'last'); // LINT
  }

  methodWithMixedArguments(someValue);
  methodWithMixedArguments(someOtherValue);

  methodWithMixedArguments(someValue, named: 'name'); // LINT
  methodWithMixedArguments(someValue, named: 'name'); // LINT
}

String methodWithArguments(String firstRegular, String secondRegular) {
  return '';
}

String methodWithNamedArguments({
  String firstName,
  String lastName,
  int age,
}) {
  return '';
}

String methodWithMixedArguments(String regular, {int? named}) {
  return '';
}
