# Avoid wrapping in padding

## Rule id {#rule-id}

avoid-wrapping-in-padding

## Severity {#severity}

Warning

## Description {#description}

Warns when a widget is wrapped in a Padding widget but has a padding settings by itself.

### Example {#example}

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
