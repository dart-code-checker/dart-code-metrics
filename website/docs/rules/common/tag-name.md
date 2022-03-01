# Tag name

## Rule id {#rule-id}

tag-name

## Severity {#severity}

Warning

## Description {#description}

Warns when tag name does not match class name.

### Config example {#config-example}

We recommend exclude the `test` folder.

```yaml
dart_code_metrics:
  ...
  rules:
    ...
    - tag-name:
        var-names: [_kTag]
        strip-prefix: _
        strip-postfix: State
    ...
```

### Example {#example}

Bad:

```dart
class Apple {
  static const _kTag = 'Orange'; // LINT
}

class _OrangeState {
  static const _kTag = 'Apple'; // LINT
}
```

Good:

```dart
class Apple {
  static const _kTag = 'Apple';
}

class _OrangeState {
  static const _kTag = 'Orange';
}
```
