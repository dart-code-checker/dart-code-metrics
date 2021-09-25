const _constRadius = BorderRadius.all(16);
final _finalRadius = BorderRadius.circular(8); // LINT

class MyWidget extends StatelessWidget {
  static final staticRadius = BorderRadius.circular(32);

  Widget build(BuildContext _) {
    final buildMethodRadius = BorderRadius.circular(230);

    return Column(children: [
      const Container(borderRadius: _constRadius),
      Container(borderRadius: BorderRadius.circular(32)),
      Container(borderRadius: staticRadius),
      Container(borderRadius: buildMethodRadius),
      Container(borderRadius: _finalRadius),
    ]);
  }
}

class BorderRadius {
  final double borderRadius;

  const BorderRadius.all(this.borderRadius);

  BorderRadius.circular(this.borderRadius);
}

class Container extends Widget {
  final Widget? child;
  final BorderRadius? borderRadius;

  const Container({this.child, this.borderRadius});
}

class Column extends Widget {
  final List<Widget> children;

  Column({required this.children});
}

class StatelessWidget extends Widget {}

class Widget {
  const Widget();
}

class BuildContext {}
