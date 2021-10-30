# No boolean literal compare

![Has auto-fix](https://img.shields.io/badge/-has%20auto--fix-success)

## Rule id {#rule-id}

no-boolean-literal-compare

## Severity {#severity}

Style

## Description {#description}

Warns on comparison to a boolean literal, as in `x == true`. Comparing boolean values to boolean literals is unnecessary, as those expressions will result in booleans too. Just use the boolean values directly or negate them.

### Unnecessary comparing {#unnecessary-comparing}

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
