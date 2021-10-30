# Avoid unused parameters

## Rule id {#rule-id}

avoid-unused-parameters

## Severity {#severity}

Warning

## Description {#description}

Checks for unused parameters inside a function or method body.
For overridden methods suggests renaming unused parameters to \_, \_\_, etc.

Note: abstract classes are completely ignored by the rule to avoid redundant checks for potentially overridden methods.

### Example {#example}

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
