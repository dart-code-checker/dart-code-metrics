class TestClass implements AbstractClass {
  String value;

  @override
  void abstractMethod(String _) {}

  void firstMethod(String string) {
    secondMethod(string);
  }

  String secondMethod(String string) {
    return string;
  }

  void thirdMethod(String value) {
    final usage = value;
  }

  void forthMethod(String firstString, String secondString) {
    firstMethod(firstString);
    secondMethod(secondString);
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

void thirdFunction(String value) {
  value = '1';
}

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
