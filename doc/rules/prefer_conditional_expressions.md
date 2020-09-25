# Prefer conditional expressions

![Has auto-fix](https://img.shields.io/badge/-has%20auto--fix-success)

## Rule id

prefer-conditional-expressions

## Description

Recommends to use a conditional expression instead of assigning to the same thing or return statement in each branch of an if statement.

### Example

Bad:

```dart
  int a = 0;

  if (a > 0) {
    a = 1;
  } else {
    a = 2;
  }

  if (a > 0) a = 1;
  else a = 2;

  int function() {
    if (a == 1) {
        return 0;
    } else {
        return 1;
    }

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
