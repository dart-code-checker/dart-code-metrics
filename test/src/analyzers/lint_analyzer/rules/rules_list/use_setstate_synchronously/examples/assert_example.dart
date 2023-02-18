class _FooState extends State<StatefulWidget> {
  Widget build(context) {
    return FooWidget(
      onChange: (value) async {
        setState(() {});
        await fetchData();
        setState(() {}); // LINT

        assert(mounted);
        setState(() {});
      },
    );
  }

  void pathologicalCases() async {
    setState(() {});

    await fetch();
    this.setState(() {}); // LINT

    if (1 == 1) {
      setState(() {}); // LINT
    } else {
      assert(mounted);
      setState(() {});
      return;
    }
    setState(() {}); // LINT

    await fetch();
    if (mounted && foo) {
      assert(mounted);
    } else {
      return;
    }
    setState(() {}); // LINT

    assert(mounted);
    setState(() {});
  }
}

class State {}
