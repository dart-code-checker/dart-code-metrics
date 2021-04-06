# Avoid returning widgets

## Rule id

avoid-returning-widgets

## Description

Warns when a method or function returns a Widget or a subclass of a Widget (**Note** `build` method will not trigger the rule).

Extracting widgets to a method is considered as a Flutter anti-pattern, because when Flutter rebuilds widget tree, it calls the function all the time, making more processor time for the operations.

Consider creating a separate widget instead of a function or method.

Additional resources:

* <https://github.com/flutter/flutter/issues/19269>
* <https://flutter.dev/docs/perf/rendering/best-practices#controlling-build-cost>
* <https://www.reddit.com/r/FlutterDev/comments/avhvco/extracting_widgets_to_a_function_is_not_an/>
* <https://medium.com/flutter-community/splitting-widgets-to-methods-is-a-performance-antipattern-16aa3fb4026c>

### Example

Bad:

```dart
class MyWidget extends StatelessWidget {
  const MyWidget();

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
        _buildShinyWidget(),
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
