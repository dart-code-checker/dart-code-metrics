# Prefer correct identifier length

![Configurable](https://img.shields.io/badge/-configurable-informational)

## Rule id

prefer-correct-identifier-length

## Description

Правило проверяет длинну имен переменных, функций классов.

Правило можно сконфигурировать при помощи полей `max-identifier-length` и `min-identifier-length`, если хотите
переопределить стандартные значения. По умолчанию `max-identifier-length = 30` и `min-identifier-length = 3`
Также можно конфигурировать какие идентификаторы стоит сканировать, а какие нет. По умолчанию все включено. Вот варианты
настроек:

`check-function-name` - имена функций;

`check-getters-name` - getters класса;

`check-setters-name` - setters класса;

`check-class-name` - имена класса;

`check-method-name` - имена методов;

`check-named-constructor-name` - именованные конструкторы;

`check-variable-name` - переменные;

`check-function-argument-name` - аргументы функций;

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
