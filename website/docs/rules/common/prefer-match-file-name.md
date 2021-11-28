# Prefer match file name

## Rule id {#rule-id}

prefer-match-file-name

## Severity {#severity}

Warning

## Description {#description}

Warns if the file name does not match the name of the first public class / mixin / extension / enum in the file or a private one if there are no public entries.

### Config example {#config-example}

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

### Example {#example}

#### Example 1 One class in the file {#example-1-one-class-in-the-file}

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

#### Example 2 Multiple class in the file {#example-2-multiple-class-in-the-file}

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
