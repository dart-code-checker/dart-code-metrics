class MyApp extends StatefulWidget {
  const MyApp();
}

class _MyAppState extends State<MyApp> {
  late final A a;
  late final B b;
  late final C c;

  @override
  void initState() {
    super.initState();

    a = context.read();
    b = context.read();
    c = context.read();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class A {}

class B {}

class C {}

class Widget {}

class StatefulWidget extends Widget {}

class BuildContext {}

extension ReadContext on BuildContext {
  T read<T>() {
    return 'value' as T;
  }
}

abstract class State<T> {
  void initState();

  void setState(VoidCallback callback) => callback();

  BuildContext get context => BuildContext();
}
