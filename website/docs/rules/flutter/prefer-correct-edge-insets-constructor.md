# Prefer correct EdgeInsets constructor

![Has auto-fix](https://img.shields.io/badge/-has%20auto--fix-success)

## Rule id {#rule-id}

prefer-correct-edge-insets-constructor

## Severity {#severity}

Style

## Description {#description}

If any value, passed to EdgeInsets.fromLTRB, equals 0, then EdgeInsets.fromLTRB should be replaced with EdgeInsets.only passing all non-zero values. If passed values are symmetric, then EdgeInsets.fromLTRB or EdgeInsets.only should be replaced with EdgeInsets.symmetric.

### Example {#example}

Bad:

```dart
EdgeInsets.fromLTRB(8, 0, 8, 0)
EdgeInsets.fromLTRB (8, 0, 0, 0)
EdgeInsets.only(left: 16, right: 16)
EdgeInsets.fromLTRB(8, 8, 8, 8)
```

Good:

```dart
EdgeInsets.symmetric(horizontal: 8)
EdgeInsets.only(left: 8)
EdgeInsets.symmetric(horizontal: 16)
EdgeInsets.all(8)
```