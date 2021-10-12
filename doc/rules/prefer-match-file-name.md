# Prefer match file name

> **DEPRECATED!** Information on this page is out of date. You can find the up to date version on our [official site](https://dartcodemetrics.dev/docs/rules/common/prefer-match-file-name).

## Rule id

prefer-match-file-name

## Description

Warns if the file name does not match the name of the first public class in the file or a private class if there are no
public classes.

### Config example

We recommend exclude the `test` folder.

```yaml
dart_code_metrics:
  ...
  rules:
    ...
    - prefer-match-file-name:
        exclude:
          - test/**
    ...
```

### Example

#### Example 1 One class in the file

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

#### Example 2 Multiple class in the file

Bad:

File name: **some_other_widget.dart**

```dart
class _SomeOtherWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //...
  }
}

class SomeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //...
  }
}
```

Good:

File name: **some_widget.dart**

```dart
class _SomeOtherWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //...
  }
}

class SomeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //...
  }
}
```
