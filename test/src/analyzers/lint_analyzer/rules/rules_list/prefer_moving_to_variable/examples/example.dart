void main() {
  final isEmpty = Theme.of('color').trim().isEmpty; // LINT
  final isNotEmpty = Theme.of('color').trim().isNotEmpty; // LINT

  final string = 'str';

  string.indexOf('').sign.bitLength.isEven; // LINT
  string.indexOf('').sign.isOdd; // LINT

  getValue().isNotEmpty; // LINT
  getValue().length; // LINT

  getValue().contains('').toString(); // LINT
  getValue().contains('asd').toString(); // LINT

  string.length;
  string.isEmpty;

  Theme.after().value.runtimeType; // LINT
  Theme.after().value.length; // LINT

  Theme.from().value.runtimeType; // LINT
  Theme.from().value.length; // LINT

  Theme.from().someMethod();
  Theme.from().someMethod();

  Theme.from().notVoidMethod(); // LINT
  Theme.from().notVoidMethod(); // LINT

  getValue(); // LINT
  getValue(); // LINT
}

class Theme {
  const value = '123';

  static String of(String value) => value;

  factory Theme.from() => Theme();

  Theme.after() {}

  void someMethod() {
    final string = 'str';

    string.indexOf('').sign.bitLength.isEven; // LINT
    string.indexOf('').sign.isOdd; // LINT
  }

  String notVoidMethod() {
    final string = 'str';

    return string;
  }
}

String getValue() => 'hello';

enum SomeValue {
  firstValue,
  secondValue,
  entry1,
  entry2,
}

class SomeClass {
  static final value = '10';

  final field = 11;
}

final instance = SomeClass();
