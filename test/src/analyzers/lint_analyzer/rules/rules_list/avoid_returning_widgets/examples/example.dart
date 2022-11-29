class MyWidget extends StatelessWidget {
  Widget _buildMyWidget(BuildContext context) {
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: _buildMyWidget,
    );
  }
}

class AnotherWidget extends StatelessWidget {
  // LINT
  Widget get widgetGetter => Container();

  String get stringGetter => '';

  Iterable<Widget> _getWidgetsIterable() => [Container()];

  List<Widget> _getWidgetsList() => [Container()].toList();

  Future<Widget> _getWidgetFuture() => Future.value(Container());

  Widget _buildMyWidget(BuildContext context) {
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    Widget _localBuildMyWidget() {
      return Container();
    }

    _localBuildMyWidget(); // LINT

    _getWidgetsIterable(); // LINT

    _getWidgetsList(); // LINT

    _getWidgetFuture(); // LINT

    _buildMyWidget(context); // LINT

    return Container(
      child: _buildMyWidget(context), // LINT
    );
  }
}

// LINT
Widget _globalBuildMyWidget() {
  return Container();
}

@FunctionalWidget
Widget _getFunctionalWidget() => Container();

@swidget
Widget _getStatelessFunctionalWidget() => Container();

@hwidget
Widget _getHookFunctionalWidget() => Container();

@hcwidget
Widget _getHookConsumerFunctionalWidget() => Container();

// LINT
@ignoredAnnotation
Widget _getWidgetWithIgnoredAnnotation() => Container();

class FunctionalWidget {
  const FunctionalWidget();
}

const swidget = FunctionalWidget();
const hwidget = FunctionalWidget();
const hcwidget = FunctionalWidget();

class IgnoredAnnotation {
  const IgnoredAnnotation();
}

class Widget {}

class Container extends Widget {
  final Widget? child;

  const Container({this.child});
}

class Builder extends Widget {
  final Widget Function(BuildContext) builder;

  const Builder(this.builder);
}

class StatelessWidget extends Widget {}

class MyOtherWidget extends StatelessWidget {
  Widget _buildMyWidget(BuildContext context) {
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return _buildMyWidget(context);
    });
  }
}

class MyAnotherWidget extends StatelessWidget {
  Widget _buildMyWidget(BuildContext context) {
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => _buildMyWidget(context),
    );
  }
}
