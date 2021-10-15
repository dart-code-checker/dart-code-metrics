# No boolean literal compare

![Has auto-fix](https://img.shields.io/badge/-has%20auto--fix-success)

> **DEPRECATED!** Information on this page is out of date. You can find the up to date version on our [official site](https://dartcodemetrics.dev/docs/rules/common/no-boolean-literal-compare).

## Rule id

no-boolean-literal-compare

## Description

Warns on comparison to a boolean literal, as in `x == true`. Comparing boolean values to boolean literals is unnecessary, as those expressions will result in booleans too. Just use the boolean values directly or negate them.

### Unnecessary comparing

Bad:

```dart
  var b = x == true; // LINT
  var c = x != true; // LINT

   // LINT
  if (x == true) {
    ...
  }

   // LINT
  if (x != false) {
    ...
  }
```

Good:

```dart
  var b = x;
  var c = !x;

  if (x) {
    ...
  }

  if (!x) {
    ...
  }
```
