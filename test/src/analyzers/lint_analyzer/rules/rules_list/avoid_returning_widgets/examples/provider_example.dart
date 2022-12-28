class MyWidget extends StatelessWidget {
  List<Provider> _getProvidersList() => [Provider()];

  MultiProvider _getMultiProvider() => MultiProvider(providers: []);

  @override
  Widget build(BuildContext context) {
    _getProvidersList();

    _getMultiProvider();

    return Container();
  }
}

class StatelessWidget extends Widget {}

class Widget {}

class Container extends Widget {
  final Widget? child;

  const Container({this.child});
}

class MultiProvider {
  final List<Widget> providers;

  const MultiProvider({required this.providers});
}

class Provider<T> extends InheritedProvider<T> {
  final Widget? child;

  const Provider(this.child);
}

class InheritedProvider<T> extends Widget {}
