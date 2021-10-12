# Avoid unused parameters

> **DEPRECATED!** Information on this page is out of date. You can find the up to date version on our [official site](https://dartcodemetrics.dev/docs/rules/common/avoid-unused-parameters).

## Rule id

avoid-unused-parameters

## Description

Checks for unused parameters inside a function or method body.
For overridden methods suggests renaming unused parameters to \_, \_\_, etc.

Note: abstract classes are completely ignored by the rule to avoid redundant checks for potentially overridden methods.

### Example

Bad:

```dart
void someFunction(String s) { // LINT
  return;
}

class SomeClass {
  void method(String s) { // LINT
    return;
  }
}

class SomeClass extends AnotherClass {
  @override
  void method(String s) {} // LINT
}
```

Good:

```dart
void someOtherFunction() {
  return;
}

class SomeOtherClass {
  void method() {
    return;
  }
}

void someOtherFunction(String s) {
  print(s);
  return;
}

class SomeOtherClass {
  void method(String s) {
    print(s);
    return;
  }
}

class SomeOtherClass extends AnotherClass {
  @override
  void method(String _) {}
}

abstract class SomeOtherClass {
  void method(String s);
}
```
