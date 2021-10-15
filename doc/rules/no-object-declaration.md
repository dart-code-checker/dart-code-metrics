# No object declaration

> **DEPRECATED!** Information on this page is out of date. You can find the up to date version on our [official site](https://dartcodemetrics.dev/docs/rules/common/no-object-declaration).

## Rule id

no-object-declaration

## Description

Warns when a class member is declared with Object type.

## Example

Bad:

```dart
class Test {
    Object data = 1; // LINT

    Object get getter => 1; // LINT

    // LINT
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
