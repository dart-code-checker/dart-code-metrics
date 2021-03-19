class TestClass implements AbstractClass {
  String value;

  @override
  void abstractMethod(String string) {}

  void firstMethod(String string) {}

  void forthMethod(String firstString, String secondString) {
    firstMethod(firstString);
  }
}

abstract class AbstractClass {
  void abstractMethod(String string);
}

void firstFunction(String string) {}

void forthFunction(String firstString, String secondString) {
  firstFunction(secondString);
}

void fifthFunction(TestClass object, String string) {
  void innerFunction(TestClass object) {
    object.value = '1';
  }

  void secondInnerFunction(TestClass object) {}

  object.firstMethod('');
}

void sixthFunction(TestClass object) {
  final func = (TestClass object) => object.value;
}
