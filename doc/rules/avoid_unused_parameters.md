# Avoid unused parameters

## Rule id

avoid-unused-parameters

## Description

Checks for unused parameters inside a function or method body.
For overridden methods suggests renaming unused parameters to \_, \_\_, etc.

Note: abstract classes are completely ignored by the rule to avoid redundant checks for potentially overridden methods.

### Example

Bad:

```dart
void someFunction(String s) {
  return;
}

class SomeClass {
  void method(String s) {
    return;
  }
}
```

Good:

```dart
void someFunction() {
  return;
}

class SomeClass {
  void method() {
    return;
  }
}

void someFunction(String s) {
  print(s);
  return;
}

class SomeClass {
  void method(String s) {
    print(s);
    return;
  }
}
```
