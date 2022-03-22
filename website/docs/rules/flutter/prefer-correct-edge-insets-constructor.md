# Prefer correct EdgeInsets constructor

![Has auto-fix](https://img.shields.io/badge/-has%20auto--fix-success)

## Rule id {#rule-id}

prefer-correct-edge-insets-constructor

## Severity {#severity}

Style

## Description {#description}

If 0 values are mostly passed into EdgeInsets.fromLTRB then it makes sense to use EdgeInsets.only for only the values that are to be used. Also if there are symmetric values passed into EdgeInsets.fromLTRB or EdgeInsets.only then it makes sense to convert this into the EdgeInsets.symmetric equivalent.

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