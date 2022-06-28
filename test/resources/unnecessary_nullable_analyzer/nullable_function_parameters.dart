// ignore_for_file: avoid-unused-parameters, no-empty-block

void doSomething(String? value) {}

// LINT
void alwaysNonNullableDoSomething(String? anotherValue) {}

void multipleParametersUsed(
  String value,
  int anotherValue, {
  required String? name,
  String? secondName,
  String? thirdName,
}) {}

// LINT
void multipleParametersWithNamed(
  String? value,
  int anotherValue, {
  required String? name,
  String? secondName,
}) {}

// LINT
void multipleParametersWithOptional(
  String? value,
  int anotherValue, [
  String? name,
  String? secondName,
]) {}
