void main() {
  dynamic s = 1; // LINT

  final result = someFunction('1', '2');

  (s as dynamic).toString(); // LINT
}

// LINT
dynamic someFunction(dynamic a, dynamic b) {
  // LINT
  if (a is dynamic) {
    return b;
  }

  return a + b;
}

typedef Json = Map<String, dynamic>;

class SomeClass {
  // LINT
  final dynamic value;

  SomeClass(this.value);

  // LINT
  dynamic get state => value;

  // LINT
  dynamic calculate() {
    return value;
  }
}

abstract class BaseClass<T> {}

class Generic extends BaseClass<dynamic> {} // LINT
