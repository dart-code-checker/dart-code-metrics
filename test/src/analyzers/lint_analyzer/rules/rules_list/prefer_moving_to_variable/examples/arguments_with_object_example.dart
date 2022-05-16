void main() {
  final state = State();

  final someValue = 'value';

  state.methodWithArguments('hello');
  state.methodWithArguments('hello', 'world');

  state.methodWithArguments('world'); // LINT
  state.methodWithArguments('world'); // LINT

  state.methodWithArguments(someValue); // LINT
  state.methodWithArguments(someValue); // LINT

  final someOtherValue = 'otherValue';
  state.methodWithArguments(someOtherValue);
  state.methodWithArguments(someValue); // LINT

  state.methodWithNamedArguments(age: 1);
  state.methodWithNamedArguments(age: 1, firstName: '');

  state.methodWithNamedArguments(firstName: 'hello'); // LINT
  state.methodWithNamedArguments(firstName: 'hello'); // LINT

  state.methodWithNamedArguments(lastName: 'last'); // LINT

  if (true) {
    state.methodWithNamedArguments(lastName: 'last'); // LINT
  }

  state.methodWithMixedArguments(someValue);
  state.methodWithMixedArguments(someOtherValue);

  state.methodWithMixedArguments(someValue, named: 'name'); // LINT
  state.methodWithMixedArguments(someValue, named: 'name'); // LINT
}

class State {
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
}
