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
  }

  // LINT
  _someOtherMethod(String value) {}
}
