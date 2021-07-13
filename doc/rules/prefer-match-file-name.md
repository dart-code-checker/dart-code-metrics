# Prefer match file name

![Configurable](https://img.shields.io/badge/-configurable-informational)

## Rule id

prefer-match-file-name

## Description

Warn when file name does not match class name

### Example

Bad:

File name: **some_widget.dart**

```dart
class SomeOtherWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //...
  }
}
```

Good:

File name: **some_widget.dart**

```dart
class SomeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //...
  }
}
```
