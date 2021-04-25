# Avoid late keyword

## Rule id

avoid-late-keyword

## Description

Warns when a field or variable is declared with a `late` keyword.

`late` keyword enforces a variable's constraints at runtime instead of at compile time and since the variable is not definitely initialized, every time it is read, a runtime check is inserted to make sure it has been assigned a value. If it hasn’t, an exception will be thrown.

Use this rule if you want to avoid unexpected runtime exceptions.

### Example

Bad:

```dart
class Test {
  late final field = 'string'; // LINT

  final String anotherField = '';

  String? nullableField;

  late String uninitializedField; // LINT

  void method() {
    late final variable = 'string'; // LINT

    final anotherVariable = '';

    String? nullableVariable;

    late String uninitializedVariable; // LINT
  }
}
```

Good:

```dart
class Test {
  final field = 'string';

  final String anotherField = '';

  String? nullableField;

  String uninitializedField;

  void method() {
    final variable = 'string';

    final anotherVariable = '';

    String? nullableVariable;

    String uninitializedVariable;
  }
}
```
