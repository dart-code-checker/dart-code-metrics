class _FooState extends State<StatefulWidget> {
  void fetchData() async {
    setState(() {});

    await fetch();
    this.setState(() {}); // LINT

    if (mounted) {
      setState(() {});
    } else {
      setState(() {}); // LINT
      return;
    }
    setState(() {});

    await fetch();
    if (!mounted) {
      setState(() {}); // LINT
      return;
    }
    setState(() {});

    await fetch();
    while (mounted) {
      setState(() {});
    }

    if (mounted) {
      await fetch();
    } else {
      return;
    }
    setState(() {}); // LINT

    if (mounted && foo) {
      setState(() {});
    }

    if (foo && !this.mounted) return;
    setState(() {});

    await fetch();
    if (!mounted || foo || foo) return;
    setState(() {});

    await fetch();
    if (mounted && foo || foo) {
      setState(() {}); // LINT
    }

    if (!mounted && foo || foo) return;
    setState(() {}); // LINT

    if (mounted && foo) {
    } else {
      return;
    }
    setState(() {}); // LINT

    if (!mounted || foo || foo) {
    } else {
      return;
    }
    setState(() {}); // LINT
  }

  Widget build(context) {
    return FooWidget(
      onChange: (value) async {
        setState(() {});
        await fetchData();
        setState(() {}); // LINT

        if (mounted) setState(() {});
      },
    );
  }

  void customConfig() async {
    await fetch();
    foobar(); // LINT
    this.foobar(); // LINT
  }
}

class State {}
