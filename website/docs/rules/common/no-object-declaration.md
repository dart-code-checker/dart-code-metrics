# No object declaration

## Rule id {#rule-id}

no-object-declaration

## Severity {#severity}

Style

## Description {#description}

Warns when a class member is declared with Object type.

## Example {#example}

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
