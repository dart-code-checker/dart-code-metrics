# Always remove listener

## Rule id {#rule-id}

always-remove-listener

## Severity {#severity}

Warning

## Description {#description}

**Note** the rule is _experimental_ and only checks for `Listenable` (and subclasses).

Warns when an event listener is added but never removed.

StatefulWidget classes sometimes add event listeners but fail to remove them. This results in memory leaks if the valueListenable lifecycle is significantly longer than the widget.

Every listener added manually needs to be removed typically in the dispose method.
If listeners are added in `didUpdateWidget` or `updateDependencies` then they also need to be removed from those methods as otherwise widgets end up with multiple listeners.

### Example {#example}

Bad:

```dart
class ShinyWidget {
  final someListener = Listener();
  final anotherListener = Listener();

  const ShinyWidget();
}

class _ShinyWidgetState extends State {
  final _someListener = Listener();
  final _anotherListener = Listener();
  final _thirdListener = Listener();
  final _disposedListener = Listener();

  const _ShinyWidgetState();

  @override
  void initState() {
    super.initState();

    _someListener.addListener(listener);
    _anotherListener.addListener(listener); // LINT
    _thirdListener.addListener(listener); // LINT
    _disposedListener.addListener(listener);

    widget.someListener.addListener(listener); // LINT

    widget.anotherListener
      ..addListener(listener)
      ..addListener(listener)
      ..addListener(() {}); // LINT
  }

  @override
  didUpdateWidget(ShinyWidget oldWidget) {
    widget.someListener.addListener(listener);
    oldWidget.someListener.removeListener(listener);

    widget.anotherListener.addListener(listener); // LINT

    _someListener.addListener(listener); // LINT

    _anotherListener.removeListener(listener);
    _anotherListener.addListener(listener);
  }

  void dispose() {
    _someListener.removeListener(listener);
    _thirdListener.removeListener(wrongListener);

    _disposedListener.dispose();

    widget.anotherListener.removeListener(listener);

    super.dispose();
  }
  
  void listener() {
    // ...
  }
  
  void wrongListener() {
    // ...
  }
}
```

Good:

```dart
class ShinyWidget {
  final someListener = Listener();
  final anotherListener = Listener();

  const ShinyWidget();
}

class _ShinyWidgetState extends State {
  final _someListener = Listener();
  final _disposedListener = Listener();

  const _ShinyWidgetState();

  @override
  void initState() {
    super.initState();

    _someListener.addListener(listener);

    _disposedListener.addListener(listener);

    widget.anotherListener.addListener(listener);
  }

  @override
  didUpdateWidget(ShinyWidget oldWidget) {
    widget.someListener.addListener(listener);
    oldWidget.someListener.removeListener(listener);

    widget.anotherListener.removeListener(listener);
    widget.anotherListener.addListener(listener);
    
    _someListener.removeListener(listener);
    _someListener.addListener(listener);
  }

  void dispose() {
    _someListener.removeListener(listener);

    _disposedListener.dispose();

    widget.anotherListener.removeListener(listener);

    super.dispose();
  }

  void listener() {
    // ...
  }
}
```
