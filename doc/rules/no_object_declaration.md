# No object declaration

## Rule id

no-object-declaration

## Description

Warns when class member is declared with Object type.

## Example

Bad:

```dart
class Test {
    Object data = 1;

    Object get getter => 1;

    Object doWork() {
        return;
    }
}
```

Good:

```dart
class Test {
    int data = 1;

    int get getter => 1;

    void doWork() {
        return;
    }
}
```
