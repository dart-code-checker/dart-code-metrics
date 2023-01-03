class TestClass {
  String value;

  void _someMethod(Function(String, int) callback) {
    callback();
  }

  void _otherMethod(String string, int value) {
    print(string);
  }

  // LINT
  void _anotherMethod(String firstString, String secondString) {
    someMethod(_otherMethod);
    _someOtherMethod(value);

    final replacement = value.isNotEmpty ? _someAnotherMethod(1, '1') : null;
  }

  // LINT
  void _someOtherMethod(String value) {}

  // LINT
  String _someAnotherMethod(
    int value,
    String name,
  ) {
    return '';
  }
}
