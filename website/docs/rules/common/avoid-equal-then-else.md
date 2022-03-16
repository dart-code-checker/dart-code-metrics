# No equal then else

## Rule id {#rule-id}

avoid-equal-then-else

## Severity {#severity}

Warning

## Description {#description}

Warns when if statement has equal then and else statements or conditional expression has equal then and else expressions.

### Example {#example}

Bad:

```dart
final firstValue = 1;
final secondValue = 2;

...

// LINT
if (condition) {
  result = firstValue;
} else {
  result = firstValue;
}

...

result = condition ? firstValue : firstValue; // LINT
```

Good:

```dart
final firstValue = 1;
final secondValue = 2;

...

if (condition) {
  result = firstValue;
} else {
  result = secondValue;
}

...

result = condition ? firstValue : secondValue;
```
