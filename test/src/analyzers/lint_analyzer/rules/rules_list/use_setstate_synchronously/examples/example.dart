class _FooState extends State<StatefulWidget> {
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

  void pathologicalCases() async {
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

    while (!mounted || foo || foo) {
      return;
    }
    setState(() {});

    while (mounted) {
      await fetch();
    }
    setState(() {}); // LINT

    if (mounted) {
      await fetch();
    }
    setState(() {}); // LINT

    if (!mounted) return;

    if (await condition()) {
      setState(() {}); // LINT
    }
  }
}

class State {}

Future<void> fetch() {}

Future<bool> condition() {}

class SomeClass {
  void setState(Function() callback) {}
}

Future<void> handle(Future Function() callback) {}

mixin _SomeMixin on SomeClass {
  Future<bool> condition() => handle(() async {
        await fetch();

        setState();
      });
}

abstract class IController {
  void setState(void Function() fn);
}

abstract class ControllerBase implements IController {
  @override
  void setState(void Function() fn) {}
}

class ControllerImpl = ControllerBase with ControllerMixin;

mixin ControllerMixin on ControllerBase {
  Future<void> helloWorld() async {
    await Future<void>.delayed(const Duration(seconds: 1));
    setState(() {});
  }
}
