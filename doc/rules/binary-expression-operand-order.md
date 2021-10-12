# Binary expression operand order

![Has auto-fix](https://img.shields.io/badge/-has%20auto--fix-success)

> **DEPRECATED!** Information on this page is out of date. You can find the up to date version on our [official site](https://dartcodemetrics.dev/docs/rules/common/binary-expression-operand-order).

## Rule id

binary-expression-operand-order

## Description

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
