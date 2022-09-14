// ignore_for_file: unnecessary-nullable, avoid-unused-parameters, no-empty-block

class IgnoredClassWithMethods {
  void someMethod(String? value) {}

  void alwaysNonNullable(String? anotherValue) {}

  void multipleParametersUsed(
    String value,
    int anotherValue, {
    required String? name,
  }) {}

  void multipleParametersWithNamed(
    String? value,
    int anotherValue, {
    required String? name,
    String? secondName,
  }) {}
}
