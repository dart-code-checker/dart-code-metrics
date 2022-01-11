class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const widget = TextButton(
      onPressed: () => null,
      child: Container(),
    );

    return TextButton(
      // LINT
      onPressed: () {
        return null;
      },
      child: Container(),
    );
  }
}

class MyOtherWidget extends StatelessWidget {
  final void Function() callback;

  const MyOtherWidget(this.callback);

  @override
  Widget build(BuildContext context) {
    final widget = TextButton(
      onPressed: _someMethod,
      child: Container(),
    );

    final anotherWidget = AnotherButton(
      Container(),
      _someMethod,
    );

    return TextButton(
      onPressed: callback,
      child: Container(),
    );
  }

  void _someMethod() {}
}

class MyAnotherWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final widget = AnotherButton(
      () => null,
      Container(),
    );

    return TextButton(
      // LINT
      onPressed: () {
        return null;
      },
      child: Container(),
      builder: (context) {
        return null;
      },
      anotherBuilder: (context, index) {
        return null;
      },
      myOtherWidgetBuilder: (context) {
        return null;
      },
    );
  }

  void _someMethod() {}
}

class MyWidgetWithEmptyCallbacks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final widget = AnotherButton(
      () {},
      Container(),
    );

    return TextButton(
      onPressed: () {
        // Just a comment here.
      },
      child: Container(),
    );
  }
}

class MyWidgetWithNestedWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextButton(
        // LINT
        onPressed: () {
          return null;
        },
        child: Container(),
      ),
    );
  }
}

class Widget {}

class StatelessWidget extends Widget {}

class BuildContext {}

class Container extends Widget {
  final Widget? child;

  const Container({this.child});
}

class TextButton {
  final Widget child;
  final void Function()? onPressed;
  final Widget Function(BuildContext)? builder;
  final Widget Function(BuildContext, int)? anotherBuilder;
  final MyOtherWidget Function(BuildContext, int)? myOtherWidgetBuilder;

  const TextButton({
    required this.child,
    required this.onPressed,
    this.builder,
    this.anotherBuilder,
    this.myOtherWidgetBuilder,
  });
}

class AnotherButton {
  final Widget child;
  final void Function()? onPressed;

  const AnotherButton(this.child, this.onPressed);
}
