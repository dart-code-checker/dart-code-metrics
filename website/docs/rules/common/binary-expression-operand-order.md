# Binary expression operand order

![Has auto-fix](https://img.shields.io/badge/-has%20auto--fix-success)

## Rule id {#rule-id}

binary-expression-operand-order

## Severity {#severity}

Style

## Description {#description}

Warns when a literal value is on the left hand side in a binary expressions.

Bad:

```dart
final a = 1 + b;
```

Good:

```dart
final a = b + 1;
```

Inspired by [TSLint rule](https://palantir.github.io/tslint/rules/binary-expression-operand-order/)
