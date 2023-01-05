class _MyState extends State {
  void awaitEmptyFuture() async {
    await Future<void>.value();
    setState(() {}); // LINT
  }

  void syncRegression() {
    doStuff();
    setState(() {});
  }

  void controlFlow() {
    await doStuff();
    for (;;) {
      if (!mounted) break;
      setState(() {});

      await doStuff();
      if (!mounted) continue;
      setState(() {});
    }

    await doStuff();
    while (true) {
      if (!mounted) break;

      setState(() {});
    }
  }
}

class State {}
