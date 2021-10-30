# Prefer extracting callbacks

![Configurable](https://img.shields.io/badge/-configurable-informational)

## Rule id {#rule-id}

prefer-extracting-callbacks

## Severity {#severity}

Style

## Description {#description}

Warns about inline callbacks in a widget tree and suggests to extract them to widget methods in order to make a `build` method more readable. In addition extracting can help test those methods separately as well.

**NOTE** the rule will not trigger on: 
 - arrow functions like `onPressed: () => _handler(...)` in order to cover cases when a callback needs a variable from the outside;
 - empty blocks.
 - Flutter specific: arguments with functions returning `Widget` type (or its subclass) and with first parameter of type `BuildContext`. "Builder" functions is a common pattern in Flutter, for example, [IndexedWidgetBuilder typedef](https://api.flutter.dev/flutter/widgets/IndexedWidgetBuilder.html) is used in [ListView.builder](https://api.flutter.dev/flutter/widgets/ListView/ListView.builder.html).

Use `ignored-named-arguments` configuration, if you want to ignore specific named parameters.

### Config example {#config-example}

```yaml
dart_code_metrics:
  ...
  rules:
    ...
    - prefer-extracting-callbacks:
        ignored-named-arguments:
          - onPressed
```

### Example {#example}

Bad:

```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ...,
      onPressed: () { // LINT
        // Some 
        // Huge
        // Callback
      },
      child: ...
    );
  }
}
```

Good:

```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ...,
      onPressed: () => handlePressed(context),
      child: ...
    );
  }
  
  void handlePressed(BuildContext context) {
    ...
  }
}

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ...,
      onPressed: handlePressed,
      child: ...
    );
  }
  
  void handlePressed() {
    ...
  }
}
```
