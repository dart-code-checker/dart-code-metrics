# Double literal format

![Has auto-fix](https://img.shields.io/badge/-has%20auto--fix-success)

## Rule id {#rule-id}

double-literal-format

## Severity {#severity}

Style

## Description {#description}

Checks that double literals should begin with `0.` instead of just `.`, and should not end with a trailing `0`. Helps keep a consistent style of numeric literals and decrease potential typos.

### Redundant leading '0' {#redundant-leading-0}

Bad:

```dart
  var a = 05.23, b = 03.6e+15, c = -012.2, d = -001.1e-15;
```

Good:

```dart
  var a = 5.23, b = 3.6e+15, c = -12.2, d = -1.1e-15;
```

### Literal begin with '.' {#literal-begin-with-}

Bad:

```dart
  var a = .257, b = .16e+5, c = -.259, d = -.14e-5;
```

Good:

```dart
  var a = 0.257, b = 0.16e+5, c = -0.259, d = -0.14e-5;
```

### Redundant trailing '0' {#redundant-trailing-0}

Bad:

```dart
  var a = 0.210, b = 0.100e+5, c = -0.250, d = -0.400e-5;
```

Good:

```dart
  var a = 0.21, b = 0.1e+5, c = -0.25, d = -0.4e-5;
```
