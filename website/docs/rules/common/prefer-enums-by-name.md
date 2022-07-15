# Prefer enums byName

## Rule id {#rule-id}

prefer-enums-by-name

## Severity {#severity}

Style

## Description {#description}

Since Dart 2.15 it's possible to use `byName` method on enum `values` prop instead of searching the value with `firstWhere`.

**Note:** `byName` will throw an exception if the enum does not contain a value for the given name.

### Example {#example}

Bad:

```dart
// LINT
final styleDefinition = StyleDefinition.values.firstWhere(
  (def) => def.name == json['styleDefinition'],
);
```

Good:

```dart
final styleDefinition = StyleDefinition.values.byName(json['styleDefinition']);
```
