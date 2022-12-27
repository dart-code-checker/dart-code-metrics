class _MyState extends State {
  void awaitEmptyFuture() async {
    await Future<void>.value();
    setState(() {}); // LINT
  }
}

class State {}
