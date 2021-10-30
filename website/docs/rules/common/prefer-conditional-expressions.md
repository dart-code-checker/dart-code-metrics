# Prefer conditional expressions

![Has auto-fix](https://img.shields.io/badge/-has%20auto--fix-success)

## Rule id {#rule-id}

prefer-conditional-expressions

## Severity {#severity}

Style

## Description {#description}

Recommends to use a conditional expression instead of assigning to the same thing or return statement in each branch of an if statement.

### Example {#example}

Bad:

```dart
  int a = 0;

  // LINT
  if (a > 0) {
    a = 1;
  } else {
    a = 2;
  }

  // LINT
  if (a > 0) a = 1;
  else a = 2;

  int function() {
    // LINT
    if (a == 1) {
        return 0;
    } else {
        return 1;
    }

    // LINT
    if (a == 2) return 0;
    else return 1;
  }
```

Good:

```dart
  int a = 0;

  a = a > 0 ? 1 : 2;

  int function() {
    return a == 2 ? 0 : 1;
  }
```
