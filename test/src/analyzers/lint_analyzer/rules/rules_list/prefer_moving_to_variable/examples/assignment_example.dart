void main() {
  final var1 = someFunction();
  final var2 = someFunction();
}

String someFunction() {
  return 'qwe';
}

class SomeClass {
  final SomeClass inner;

  String _value = '123';

  String get value => _value;
  set(String value) {
    _value = value;
  }

  void method() {
    final first = inner.inner.value;
    inner.inner.value = 'hello';
  }
}
