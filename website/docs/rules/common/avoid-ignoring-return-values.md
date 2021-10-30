# Avoid ignoring return values

## Rule id {#rule-id}

avoid-ignoring-return-values

## Severity {#severity}

Warning

## Description {#description}

Warns when a return value of a method or function invocation or a class instance property access is not used.

Silently ignoring such values might lead to a potential error especially when the invocation target is an immutable instance which has all its methods returning a new instance (for example, String or DateTime classes).

### Example {#example}

Bad:

```dart
int foo() {
    return 5;
}

void bar() {
    print('whatever');
}

void main() {
    bar();
    foo(); // LINT: return value is silently ignored

    final str = "Hello there";
    str.substr(5); // LINT: Strings are immutable and the return value should be handled

    final date = new DateTime(2018, 1, 13);
    date.add(Duration(days: 1, hours: 23))); // LINT: Return value ignored, DateTime is immutable
}
```

Good:

```dart
int foo() {
    return 5;
}

void bar() {
    print('whatever');
}

void main() {
    bar();
    final f = foo();

    final str = "Hello there";
    final newString = str.substr(5);

    final date = new DateTime(2018, 1, 13);
    final newDate = date.add(Duration(days: 1, hours: 23)));
}
```
