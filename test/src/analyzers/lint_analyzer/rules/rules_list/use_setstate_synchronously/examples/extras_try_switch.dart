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

  void switchStatements() async {
    await doStuff();
    switch (foobar) {
      case 'foo':
        if (!mounted) break;
        setState(() {});
        break;
      case 'bar':
        setState(() {}); // LINT
        break;
      case 'baz':
        await doStuff();
        break;
    }
    setState(() {}); // LINT
  }

  void switchAsync() async {
    switch (foobar) {
      case 'foo':
        await doStuff();
        return;
    }
    setState(() {});
  }
}

class State {}
