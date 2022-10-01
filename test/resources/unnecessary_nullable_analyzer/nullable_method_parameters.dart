// ignore_for_file: avoid-unused-parameters, no-empty-block

class ClassWithMethods {
  void someMethod(String? value) {}

  // LINT
  void alwaysNonNullable(String? anotherValue) {}

  void multipleParametersUsed(
    String value,
    int anotherValue, {
    required String? name,
  }) {}

  // LINT
  void multipleParametersWithNamed(
    String? value,
    int anotherValue, {
    required String? name,
    String? secondName,
  }) {}

  // ignore: unnecessary-nullable
  void ignoredAlwaysNonNullable(String? anotherValue) {}
}
