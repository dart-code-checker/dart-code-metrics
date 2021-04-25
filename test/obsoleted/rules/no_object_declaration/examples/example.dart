class Test {
  Object data = 1; // LINT

  Object get getter => 1; // LINT

  // LINT
  Object doWork() {
    return null;
  }
}

class AnotherTest {
  int data = 1;

  int get getter => 1;

  void doWork() {
    return;
  }

  void doAnotherWork(Object param) {
    return;
  }
}

Object a = 1;

Object function(Object param) {
  return null;
}
