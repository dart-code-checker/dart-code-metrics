# Prefer immediate return

![Has auto-fix](https://img.shields.io/badge/-has%20auto--fix-success)

## Rule id {#rule-id}

prefer-immediate-return

## Severity {#severity}

Style

## Description {#description}

Declaring a local variable only to immediately return it might be considered a bad practice. The name of a function or a class method with its return type should give enough information about what should be returned.

### Example {#example}

Bad:

```dart
void calculateSum(int a, int b) {
    final sum = a + b;
    return sum; // LINT
}

void calculateArea(int width, int height) {
    final result = width * height;
    return result; // LINT
}
```

Good:

```dart
void calculateSum(int a, int b) {
    return a + b;
}

void calculateArea(int width, int height) => width * height;
```
