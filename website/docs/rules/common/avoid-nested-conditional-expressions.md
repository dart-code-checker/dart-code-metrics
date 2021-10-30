# Avoid nested conditional expressions

![Configurable](https://img.shields.io/badge/-configurable-informational)

## Rule id {#rule-id}

avoid-nested-conditional-expressions

## Severity {#severity}

Style

## Description {#description}

Checks for nested conditional expressions.

Use `acceptable-level` configuration, if you want to set the acceptable nesting level (default is 1).

### Config example {#config-example}

```yaml
dart_code_metrics:
  ...
  rules:
    ...
    - avoid-nested-conditional-expressions:
        acceptable-level: 2
```

### Example {#example}

Bad:

```dart
final str = '';

final oneLevel = str.isEmpty ? 'hi' : '1';

final twoLevels = str.isEmpty
    ? str.isEmpty // LINT
        ? 'hi'
        : '1'
    : '2';

final threeLevels = str.isEmpty
    ? str.isEmpty // LINT
        ? str.isEmpty // LINT
            ? 'hi'
            : '1'
        : '2'
    : '3';
```

Good:

```dart
final str = '';

final oneLevel = str.isEmpty ? 'hi' : '1';

final twoLevels = _getStr(str);

String _getStr(String str) {
    if (str.isEmpty) {
        return 'hi';
    }

    ...
}
```
