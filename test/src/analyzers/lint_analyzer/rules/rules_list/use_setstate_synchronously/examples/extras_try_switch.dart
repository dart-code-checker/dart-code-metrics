class MyState extends State {
  void tryStatements() async {
    try {
      await doStuff();
    } on FooException {
      if (!mounted) return;
      setState(() {});
    } on BarException {
      setState(() {}); // LINT
    }
    setState(() {}); // LINT
  }

  void tryFinally() async {
    try {
      await doStuff();
    } on Exception {
      await doStuff();
    } finally {
      if (!mounted) return;
    }
    setState(() {});
  }
}

class State {}
