# Prefer correct type name

![Configurable](https://img.shields.io/badge/-configurable-informational)

## Rule id

prefer-correct-type-name

## Severity {#severity}

Style

## Description

Rule checks that the type name should only contain alphanumeric characters, start with an uppercase character and span between `min-length` and `max-length` characters in length.

The rule can be configured using fields `min-length` and `max-length`. By default it's `min-length = 3` and `max-length = 40`. You can also configure type name exceptions with `excluded` option.

### Config example

```yaml
dart_code_metrics:
  ...
  rules:
    ...
    - prefer-correct-type-name:
        excluded: [ 'exampleExclude' ]
        min-length: 3
        max-length: 40
```

### Example

Bad:

```dart
class example { // not capitalized
  //...
} 
class ex { // length equals 2
  //...
} 
class multiplatformConfigurationPointWithExtras { // length equals 41
  //...
} 
```

Good:

```dart
class Example { // length equals 7
  //...
}

class _Example { // length equals 7
  //...
} 
```
