# No magic number

## Rule id
no-magic-number

## Description
Warns against using number literals outside of named constants.
Exception is made for common constants: -1, 0 and 1.

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
