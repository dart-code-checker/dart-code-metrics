# Avoid unnecessary type casts

## Rule id

avoid-unnecessary-type-casts

## Severity {#severity}

Warning

## Description

Warns about of unnecessary use of casting operators.

### Example

```dart
class Example {
  final myList = <int>[1, 2, 3];

  void main() {
    final result = myList as List<int>; // LINT
  }
}
```
