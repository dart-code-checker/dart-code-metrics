# Prefer correct identifier length

![Configurable](https://img.shields.io/badge/-configurable-informational)

## Rule id

prefer-correct-identifier-length

## Description

Very short identifier names or very long can make code harder to read and potentially less maintainable. To prevent this, one may enforce a minimum and/or maximum identifier length.


Use `max-identifier-length` and `min-identifier-length` configuration, if you want to override the default value. Default value for `max-identifier-length = 30` and `min-identifier-length = 3` 

### Config example

```yaml
dart_code_metrics:
  ...
  rules:
    ...
    - prefer-correct-identifier-length:
      max-identifier-length: 40
      min-identifier-length: 4
      check-variable-name: false
      check-function-name: false
      check-class-name: false
```

### Example

Bad:

```dart
var x = 0; //length 1
var multiplatformConfigurationPoint = 0; //length 31
```

Good:

```dart
var property = 0; //length 8
var multiplatformConfiguration = 0; //length 26
```
