# Prefer correct identifier length

![Configurable](https://img.shields.io/badge/-configurable-informational)

## Rule id

prefer-correct-identifier-length

## Severity {#severity}

Style

## Description

The rule checks the length of variable names in classes, functions, extensions, mixins, and also checks the value of enum.

The rule can be configured using fields `max-identifier-length` and `min-identifier-length`. By
default `max-identifier-length = 300` and `min-identifier-length = 3`. You can also add
exceptions `exceptions`.

### Config example

```yaml
dart_code_metrics:
  ...
  rules:
    ...
    - prefer-correct-identifier-length:
        exceptions: [ 'z' ]
        max-identifier-length: 30
        min-identifier-length: 4
```

### Example

Bad:

```dart

var x = 0; // length equals 1
var multiplatformConfigurationPoint = 0; // length equals 31
```

Good:

```dart

var property = 0; // length equals 8
var multiplatformConfiguration = 0; // length equals 26
```
