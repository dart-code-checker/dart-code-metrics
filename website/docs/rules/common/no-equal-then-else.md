# No equal then else

## Rule id {#rule-id}

no-equal-then-else

## Severity {#severity}

Warning

## Description {#description}

Warns when if statement has equal then and else statements or conditional expression has equal then and else expressions.

### Example {#example}

Bad:

```dart
final value1 = 1;
final value2 = 2;

...

// LINT
if (condition) {
  result = value1;
} else {
  result = value1;
}

...

result = condition ? value1 : value1; // LINT
```

Good:

```dart
final value1 = 1;
final value2 = 2;

...

if (condition) {
  result = value1;
} else {
  result = value2;
}

...

result = condition ? value1 : value2;
```
