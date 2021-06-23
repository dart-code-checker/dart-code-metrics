class MyHomePage<T> extends StatefulWidget {
  const MyHomePage({
    required this.title,
    required this.controller,
    Key? key,
  }) : super(key: key);

  final String title;
  final ValueNotifier<T> controller;

  @override
  _MyHomePageState createState() => _MyHomePageState<T>();
}

class _MyHomePageState<T> extends State<MyHomePage> {
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_incrementCounter);
    widget.controller.addListener(_callback);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_incrementCounter);
    widget.controller.removeListener(_callback);
    super.dispose();
  }

  void _incrementCounter() => setState(() {
        _counter++;
      });

  T _callback<T>() {}
}

class State<T> {
  final _w = MyHomePage<bool>();
  MyHomePage get widget => _w;
}

class ValueNotifier<T> implements Listenable {
  T _value;

  ValueNotifier(this._value);

  @override
  T get value => _value;
}

abstract class Listenable {
  const Listenable();

  factory Listenable.merge(List<Listenable?> listenables) = _MergingListenable;

  void addListener(VoidCallback listener);

  void removeListener(VoidCallback listener);
}
