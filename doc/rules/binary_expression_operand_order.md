# Binary expression operand order

![Has auto-fix](https://img.shields.io/badge/-has%20auto--fix-success)

## Rule id
binary-expression-operand-order

## Description
Issue a warning when literal value is on left hand side in binary expressions.

Bad:
```dart
final a = 1 + b;
```

Good:
```dart
final a = b + 1;
```

Inspired by [TSLint rule](https://palantir.github.io/tslint/rules/binary-expression-operand-order/)
