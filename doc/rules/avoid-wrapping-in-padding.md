# Avoid wrapping in padding

## Rule id

avoid-wrapping-in-padding

## Description

Warns when a widget is wrapped in a Padding widget but has a padding settings by itself.

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
