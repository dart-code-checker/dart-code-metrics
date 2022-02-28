abstract class A {}

class B extends A {} // LINT

abstract class C {
  int get a;
}

class D extends C {
  // LINT
  // Implementation
}

abstract class E {
  int get a;
}

abstract class G extends E {
  // LINT
  String get b;
}

class K extends G {
  // LINT
  // Implementation
}
