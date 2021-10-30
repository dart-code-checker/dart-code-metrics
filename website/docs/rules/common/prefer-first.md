# Prefer first

![Has auto-fix](https://img.shields.io/badge/-has%20auto--fix-success)

## Rule id {#rule-id}

prefer-first

## Severity {#severity}

Style

## Description {#description}

Warns when the first element of an Iterable or a List is accessed by `list[0]` or `iterable.elementAt(0)` instead of calling `iterable.first`.

### Example {#example}

Bad:

```dart
...
const array = [1, 2, 3, 4, 5, 6, 7, 8, 9];

array.elementAt(0); // LINT
array[0]; // LINT
```

Good:

```dart
const array = [1, 2, 3, 4, 5, 6, 7, 8, 9];

array.first;
```
