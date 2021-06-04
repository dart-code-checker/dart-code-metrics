# No magic number

![Configurable](https://img.shields.io/badge/-configurable-informational)

## Rule id

no-magic-number

## Description

Warns against using number literals outside of named constants or variables. Exceptions are made for common constants (by default: -1, 0 and 1) and for literals inside `DateTime` constructor as there is no way to create `const DateTime` and extracting each `int` argument to separate named constant is far too inconvenient.

## Example

Bad:

```dart
double circleArea(double radius) => 3.14 * pow(radius, 2); // warns against 3.14
```

Good:

```dart
const pi = 3.14;
double circleArea(double radius) => pi * pow(radius, 2); // using named constant so no warning
```

Bad:

```dart
...
final finalPrice = cart.productCount > 4 // warns against 4
  ? cart.totalPrice - (cart.totalPrice * 0.25); // warns against 0.25
  : cart.totalPrice
...
```

Good:

```dart
...
const productCountThresholdForDiscount = 4;
const discount = 0.25;
final finalPrice = cart.productCount > productCountThresholdForDiscount
  ? cart.totalPrice - (cart.totalPrice * discount);
  : cart.totalPrice
...
```

Exception:

```dart
final someDay = DateTime(2006, 12, 1); // DateTime has no const constructor
```

## Config example

```yaml
dart_code_metrics:
  ...
  rules:
    ...
    - no-magic-number:
        allowed: [3.14, 100, 12]
```
