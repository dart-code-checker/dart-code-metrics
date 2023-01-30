class _FooState extends State<StatefulWidget> {
  Widget build(BuildContext context) {
    return FooWidget(
      onChange: (value) async {
        setState(() {});
        await fetchData();

        if (context.mounted) setState(() {});
      },
    );
  }
}

typedef VoidCallback = void Function();

class State {
  void setState(VoidCallback callback) {}
}

class BuildContext {
  bool get mounted => true;
}

Future<String> fetchData() => Future.value('123');
