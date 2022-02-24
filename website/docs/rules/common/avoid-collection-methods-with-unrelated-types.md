# Avoid collection methods with unrelated types

## Rule id {#rule-id}

avoid-collection-methods-with-unrelated-types

## Severity {#severity}

Warning

## Description {#description}

Avoid using collection methods with unrelated types, such as accessing a map of integers using a string key.

This lint has been requested for a long time: Follow [this link](https://github.com/dart-lang/linter/issues/1307) to see the details.

Related: Dart's built-in `list_remove_unrelated_type` and `iterable_contains_unrelated_type`.

### Example {#example}

Bad:

```dart
final map = Map<int, String>();
map["str"] = "value";
```

Good:

```dart
final map = Map<int, String>();
map[42] = "value";
```
