class Test {
  String _value;

  void doWork() {}

  void doAnotherWork() {}

  final data = 1; // LINT

  Test();

  String _doWork() => 'test';

  void _doAnotherWork() {}

  String get value => _value; // LINT

  set value(String str) => _value = str;
}
