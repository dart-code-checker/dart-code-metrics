# Avoid unrelated type assertions

## Rule id

avoid-unrelated-type-assertions

## Severity {#severity}

Warning

## Description

Warns about unrelated usages of 'is' operator.

### Example

Bad:

```dart
class Animal {}

class NotAnimal {}

class Example {
  final regularString = '';
  final myList = <int>[1, 2, 3];

  final Animal animal = Animal();

  void main() {
    final result = regularString is int; // LINT
    final result2 = myList is List<String>; // LINT

    final result3 = animal is NotAnimal; // LINT
  }
}
```

Good:

```dart
class Animal {}

class Example {
  final regularString = '';
  final myList = <int>[1, 2, 3];

  final Animal animal = Animal();

  void main() {
    final result = regularString is String;
    final result2 = myList is List<int>;

    final result3 = animal is Object;
  }
}
```
