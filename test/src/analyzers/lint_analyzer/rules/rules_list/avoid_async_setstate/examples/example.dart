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
}

class State {}
