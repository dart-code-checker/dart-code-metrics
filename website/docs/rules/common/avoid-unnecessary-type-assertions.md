# Avoid unnecessary type assertions

## Rule id

avoid-unnecessary-type-assertions

## Severity {#severity}

Warning

## Description

Warns about unnecessary usage of 'is' and 'whereType' operators.

### Example

#### Example 1 Check is same type

```dart
class Example {
  final myList = <int>[1, 2, 3];

  void main() {
    final result = myList is List<int>; // LINT
    myList.whereType<int>();
  }
}
```

#### Example 2 whereType method

```dart
main(){
  ['1', '2'].whereType<String?>(); // LINT
}
```
