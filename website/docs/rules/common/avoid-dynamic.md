# Avoid dynamic

## Rule id {#rule-id}

avoid-dynamic

## Severity {#severity}

Warning

## Description {#description}

Warns when `dynamic` type is used as variable type in declaration, return type of a function, etc. Using `dynamic` is considered unsafe since it can easily result in runtime errors.

**Note:** using `dynamic` type for `Map<>` is considered fine since there is no better way to declare type of JSON payload.

### Example {#example}

Bad:

```dart
dynamic x = 10; // LINT

// LINT
String concat(dynamic a, dynamic b) {
  return a + b;
}
```

Good:

```dart
int x = 10;

final x = 10;

String concat(String a, String b) {
  return a + b;
}
```
