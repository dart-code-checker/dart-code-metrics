class MyWidget {
  final someListener = Listener();
  final anotherListener = Listener();

  const MyWidget();
}

class _MyWidgetState extends State {
  final _someListener = Listener();
  final _anotherListener = Listener();
  final _thirdListener = Listener();

  const _MyWidgetState();

  @override
  void initState() {
    super.initState();

    _someListener.addListener(listener);
    _anotherListener.addListener(listener); // LINT
    _thirdListener.addListener(listener); // LINT

    widget.someListener.addListener(listener); // LINT

    widget.anotherListener
      ..addListener(listener)
      ..addListener(listener)
      ..addListener(() {}); // LINT
  }

  @override
  didUpdateWidget(MyWidget oldWidget) {
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

    widget.anotherListener.removeListener(listener);

    super.dispose();
  }

  void listener() => print('empty');

  void wrongListener() => print('wrong');
}

class Listener implements Listenable {}

class State {
  MyWidget get widget => MyWidget();
}

// Copy-pasted from Flutter source code
abstract class Listenable {
  const Listenable();

  factory Listenable.merge(List<Listenable?> listenables) = _MergingListenable;

  void addListener(VoidCallback listener);

  void removeListener(VoidCallback listener);
}

typedef VoidCallback = void Function();
