# Avoid non null assertion

## Rule id {#rule-id}

avoid-non-null-assertion

## Severity {#severity}

Warning

## Description {#description}

Warns when non null assertion operator (**!** or “bang” operator) is used for a property access or method invocation. The operator check works at runtime and it may fail and throw a runtime exception.

The rule ignores the index `[]` operator on the Map class because it's considered the idiomatic way to access a known-present element in a map with `[]!` according to [the docs](https://dart.dev/null-safety/understanding-null-safety#the-map-index-operator-is-nullable).

Use this rule if you want to avoid possible unexpected runtime exceptions.

### Example {#example}

Bad:

```dart
class Test {
  String? field;

  Test? object;

  void method() {
    field!.contains('other'); // LINT

    object!.field!.contains('other'); // LINT

    final map = {'key': 'value'};
    map['key']!.contains('other');

    object!.method(); // LINT
  }
}
```

Good:

```dart
class Test {
  String? field;

  Test? object;

  void method() {
    field?.contains('other');

    object?.field?.contains('other');

    final map = {'key': 'value'};
    map['key']!.contains('other');

    object?.method();
  }
}
```
