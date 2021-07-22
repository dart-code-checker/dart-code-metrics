# Prefer single widget per file

## Rule id

prefer-trailing-comma

## Description

A file may not contain more than one widget.

Ensures that files have a single responsibility so that that widget each exist in their own files.

```dart
function('some string', () {
  return;
});
```

### Example

Bad:

some_widgets.dart

```dart
class someWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ...
  }
}

// LINT
class someOtherWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ...
  }
}

// LINT
class _someOtherWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ...
  }
}

// LINT
class someStatefulWidget extends StatefulWidget {
  @override
  _someStatefulWidgetState createState() => _someStatefulWidgetState();
}

class _someStatefulWidgetState extends State<InspirationCard> {
  @override
  Widget build(BuildContext context) {
    ...
  }
}
```

Good:

some_widget.dart

```dart
class someWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ...
  }
}
```

some_other_widget.dart

```dart
class someOtherWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ...
  }
}
```
