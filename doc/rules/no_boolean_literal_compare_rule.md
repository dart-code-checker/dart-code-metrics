# No boolean literal compare

## Rule id
no-boolean-literal-compare

## Description
Warns on comparison to a boolean literal, as in `x == true`. Comparing boolean values to boolean literals is unnecessary, as those expressions will result in booleans too. Just use the boolean values directly or negate them.

### Unnecessary comparing
Bad:
```dart
  var b = x == true;
  var c = x != true;

  if (x == true) {
    ...
  }

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
