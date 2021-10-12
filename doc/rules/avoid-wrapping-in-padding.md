# Avoid wrapping in padding

> **DEPRECATED!** Information on this page is out of date. You can find the up to date version on our [official site](https://dartcodemetrics.dev/docs/rules/flutter/avoid-wrapping-in-padding).

## Rule id

avoid-wrapping-in-padding

## Description

Warns when a widget is wrapped in a `Padding(...)` widget but has a padding settings by itself.

### Example

Bad:

```dart
class CoolWidget {
  ...

  Widget build(...) {
    // LINT
    return Padding(
      child: Container(),
    );
  }
}
```

Good:

```dart
class CoolWidget {
  Widget build() {
    return Container();
  }
}

class AnotherWidget {
  Widget build() {
    return Padding(
      child: Icon();
    );
  }
}
```
