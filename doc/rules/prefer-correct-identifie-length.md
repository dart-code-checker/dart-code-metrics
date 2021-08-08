# Prefer correct identifier length

## Rule id

prefer-correct-identifier-length

## Description

Very short identifier names or very long can make code harder to read and potentially less maintainable. To prevent this, one may enforce a minimum and/or maximum identifier length.

### Example

Bad:

```dart
var x = 0;
```

Good:

```dart
var property = 0;
```
