# Prefer commenting analyzer ignores

## Rule id

prefer-commenting-analyzer-ignores

## Severity {#severity}

Warning

## Description

Warns when `// ignore:` comments are left without any additional description why this ignore is applied.

This rule doesn't trigger on global `ignore_for_file:` comments.

### Example

Bad:

```dart
// ignore: deprecated_member_use
final map = Map(); // LINT

// ignore: deprecated_member_use, long-method
final set = Set(); // LINT
```

Good:

```dart
// Ignored for some reasons
// ignore: deprecated_member_use
final list = List();

// ignore: deprecated_member_use same line ignore
final queue = Queue();

// ignore: deprecated_member_use, long-method multiple same line ignore
final linkedList = LinkedList();
```
