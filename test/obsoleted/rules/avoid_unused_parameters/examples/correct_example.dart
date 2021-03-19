class TestClass implements AbstractClass {
  String value;

  String get getter => value;

  @override
  void abstractMethod(String _) {}

  void speciallySkippedMethod(String _) {}

  bool chainReturnMethod(TestClass object) {
    return object?.value?.isEmpty;
  }

  external void externalMethod(String string);

  void firstMethod(String string) {
    thirdMethod(string);
  }

  String secondMethod(String string) {
    return string;
  }

  void thirdMethod(String value) {
    final usage = value;
  }

  void forthMethod(String firstString, String secondString) {
    firstMethod(firstString);
    thirdMethod(secondString);
  }

  void fifth(TestClass object) {
    object.value = '1';
  }

  void sixth(TestClass object) {
    object.firstMethod('');
  }
}

abstract class AbstractClass {
  void abstractMethod(String string);
}

void firstFunction(String string) {
  secondMethod(string);
}

String secondFunction(String string) {
  assert(string != null);
}

external void thirdFunction(String string);

void forthFunction(String firstString, String secondString) {
  firstFunction(firstString);
  secondFunction(secondString);
}

void fifthFunction(TestClass object, String string) {
  void innerFunction(TestClass object) {
    object.value = string;
  }

  object.firstMethod('');
}

void sixthFunction(TestClass object) {
  final func = (TestClass object) => object.value;
  object.firstMethod('');
}
