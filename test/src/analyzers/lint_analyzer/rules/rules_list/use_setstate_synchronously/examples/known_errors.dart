class _MyState extends State {
  void awaitEmptyFuture() async {
    await Future<void>.value();
    setState(() {}); // LINT
  }

  void syncRegression() {
    doStuff();
    setState(() {});
  }
}

class State {}
