# Prefer extracting callbacks

## Rule id

prefer-extracting-callbacks

## Description

Warns about inline callbacks in a widget tree and suggests to extract them to widget methods in order to make a `build` method more readable. In addition extracting can help test those methods separately as well.

**NOTE** the rule will not trigger for lambdas, like `onPressed: () => _handler(...)`, in order to cover cases when a callback needs a variable from the outside.

### Example

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
