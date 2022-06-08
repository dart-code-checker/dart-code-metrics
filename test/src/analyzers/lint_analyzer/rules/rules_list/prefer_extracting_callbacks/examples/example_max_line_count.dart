class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const a = TextButton(
      onPressed: () => null,
      child: Container(),
    );

    const b = TextButton(
      onPressed: () {
        firstLine();
        secondLine();
        thirdLine();
      },
      child: Container(),
    );

    const c = TextButton(
      // LINT
      onPressed: () {
        firstLine();
        secondLine();
        thirdLine();
        fourthLine();
      },
      child: Container(),
    );

    return Container();
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
