# Avoid global state

## Rule id {#rule-id}

avoid-global-state

## Severity {#severity}

Warning

## Description {#description}

The rule should violate on not final and non-const top-level variables.

Having many mutable global variables inside application is a pretty bad practice:

- application state becomes distributed between multiple files
- application state is not protected: it can be modified in almost any place
- it might be hard to debug such applications

So the common practice is to use state management solutions instead of mutable global variables.

### Example {#example}

Bad:

```dart
var answer = 42; // LINT
var evenNumbers = [1, 2, 3].where((element) => element.isEven); // LINT

class Foo {
  static int? bar; // LINT
}
```

Good:

```dart
const answer = 42;
final evenNumbers = [1, 2, 3].where((element) => element.isEven);

class Foo {
  static int bar = 42;
}
```
