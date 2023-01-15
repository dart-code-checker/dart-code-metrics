class Test {
  late final field = 'string'; // LINT

  final String anotherField = '';

  String? nullableField;

  late int uninitializedField; // LINT

  void method() {
    late final variable = 'string'; // LINT

    final anotherVariable = '';

    String? nullableVariable;

    late String uninitializedVariable; // LINT
  }
}

late final topLevelVariable = 'string'; // LINT

late String topLevelUninitializedVariable; // LINT
