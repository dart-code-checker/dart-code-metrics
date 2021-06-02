# Avoid returning widgets

![Configurable](https://img.shields.io/badge/-configurable-informational)

## Rule id

avoid-returning-widgets

## Description

Warns when a method, function or getter returns a Widget or subclass of a Widget.

The following patterns will not trigger the rule:

- Widget `build` method overrides.
- Class method that is passed to a builder.
- Functions with [functional_widget](https://pub.dev/packages/functional_widget) package annotations.

Extracting widgets to a method is considered as a Flutter anti-pattern, because when Flutter rebuilds widget tree, it calls the function all the time, making more processor time for the operations.

Consider creating a separate widget instead of a function or method.

Additional resources:

- <https://github.com/flutter/flutter/issues/19269>
- <https://flutter.dev/docs/perf/rendering/best-practices#controlling-build-cost>
- <https://www.reddit.com/r/FlutterDev/comments/avhvco/extracting_widgets_to_a_function_is_not_an/>
- <https://medium.com/flutter-community/splitting-widgets-to-methods-is-a-performance-antipattern-16aa3fb4026c>

Use `ignored-names` configuration, if you want to ignore a function or method name.

Use `ignored-annotations` configuration, if you want to override default ignored annotation list.

For example:

### Config example

```yaml
dart_code_metrics:
  ...
  rules:
    ...
    - avoid-returning-widgets:
        ignored-names:
          - testFunction
        ignored-annotations:
          - allowedAnnotation
```

will ignore all functions named `testFunction` and all functions having `allowedAnnotation` annotation.

### Example

Bad:

```dart
class MyWidget extends StatelessWidget {
  const MyWidget();

  // LINT
  Widget _getWidget() => Container();

  Widget _buildShinyWidget() {
    return Container(
      child: Column(
        children: [
          Text('Hello'),
          ...
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('Text!'),
        ...
        _buildShinyWidget(), // LINT
      ],
    );
  }
}
```

Good:

```dart
class MyWidget extends StatelessWidget {
  const MyWidget();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('Text!'),
        ...
        const _MyShinyWidget(),
      ],
    );
  }
}

class _MyShinyWidget extends StatelessWidget {
  const _MyShinyWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text('Hello'),
          ...
        ],
      ),
    );
  }
}
```

Good:

```dart
class MyWidget extends StatelessWidget {
  Widget _buildMyWidget(BuildContext context) {
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: _buildMyWidget,
    );
  }
}
```
