class Test {
  final value = 1;

  String a;

  String z;

  double f; // LINT

  double e;

  int x;

  // LINT
  String work() {
    return '';
  }

  bool create() => false; // LINT

  void init() {} // LINT
}
