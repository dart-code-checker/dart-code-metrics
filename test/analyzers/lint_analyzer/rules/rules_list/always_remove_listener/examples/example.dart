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

  void listener() => print('empty');

  void wrongListener() => print('wrong');
}

class Listener implements Listenable {
  void dispose() {}
}

class State {
  ShinyWidget get widget => ShinyWidget();
}

// Copy-pasted from Flutter source code
abstract class Listenable {
  const Listenable();

  factory Listenable.merge(List<Listenable?> listenables) = _MergingListenable;

  void addListener(VoidCallback listener);

  void removeListener(VoidCallback listener);
}

typedef VoidCallback = void Function();
