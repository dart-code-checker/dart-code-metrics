class MyApp extends StatefulWidget {
  const MyApp();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    final model = MyModel(
      context.read(),
      context.read(),
      context.read(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class A {}

class B {}

class C {}

class MyModel {
  final A a;
  final B b;
  final C c;

  const MyModel(this.a, this.b, this.c);
}

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
