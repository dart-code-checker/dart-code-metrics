class Test {
  String _value;

  static const staticConstField = ''; // LINT

  late final staticLateFinalField; // LINT

  String? nullableField; // LINT

  late String? lateNullableField; // LINT

  void doWork() {}

  void doAnotherWork() {}

  final data = 1; // LINT

  Test();

  factory Test.empty() => Test();

  Test.create();

  String _doWork() => 'test';

  void _doAnotherWork() {}

  String get value => _value; // LINT

  set value(String str) => _value = str;
}
