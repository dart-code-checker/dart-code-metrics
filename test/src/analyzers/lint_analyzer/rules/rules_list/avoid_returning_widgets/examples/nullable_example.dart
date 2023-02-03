class AnotherWidget extends StatelessWidget {
  Widget? get widgetGetter => Container();

  List<Widget>? _getWidgetsList() => [Container()].toList();

  @override
  Widget build(BuildContext context) {
    Widget? _localBuildMyWidget() {
      return Container();
    }

    _localBuildMyWidget();

    _getWidgetsList();

    return Container();
  }
}

Widget? _globalBuildMyWidget() {
  return Container();
}

class Widget {}

class Container extends Widget {
  final Widget? child;

  const Container({this.child});
}

class StatelessWidget extends Widget {}
