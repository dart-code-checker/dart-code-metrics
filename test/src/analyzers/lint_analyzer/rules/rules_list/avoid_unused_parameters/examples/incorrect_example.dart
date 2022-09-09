class TestClass implements AbstractClass {
  String value;

  @override
  void abstractMethod(String string) {}

  // LINT
  void firstMethod(String string) {}

  // LINT
  void forthMethod(String firstString, String secondString) {
    firstMethod(firstString);
  }
}

abstract class AbstractClass {
  void abstractMethod(String string);
}

// LINT
void firstFunction(String string) {}

// LINT
void forthFunction(String firstString, String secondString) {
  firstFunction(secondString);
}

// LINT
void fifthFunction(TestClass object, String string) {
  void innerFunction(TestClass object) {
    object.value = '1';
  }

  // LINT
  void secondInnerFunction(TestClass object) {}

  object.firstMethod('');
}

// LINT
void sixthFunction(TestClass object) {
  final func = (TestClass object) => object.value;
}

mixin AbstractMixin {
  // LINT
  String secondMethod(String string) {
    return 'string';
  }
}

// LINT
int shadowing(String value) {
  final value = 1;

  return value;
}
