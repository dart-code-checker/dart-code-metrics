class EdgeInsets {
  final double top;
  final double left;
  final double right;
  final double bottom;

  const EdgeInsets.fromLTRB(this.left, this.top, this.right, this.bottom);

  const EdgeInsets.all(double value)
      : left = value,
        top = value,
        right = value,
        bottom = value;

  const EdgeInsets.only({
    this.left = 0.0,
    this.top = 0.0,
    this.right = 0.0,
    this.bottom = 0.0,
  });

  static const EdgeInsets zero = EdgeInsets.only();

  const EdgeInsets.symmetric({
    double vertical = 0.0,
    double horizontal = 0.0,
  })  : left = horizontal,
        top = vertical,
        right = horizontal,
        bottom = vertical;
}

class Column extends Widget {
  final List<Widget> children;

  Column({required this.children});
}

class Container extends Widget {
  final EdgeInsets padding;

  Container({required this.padding});
}

class StatelessWidget extends Widget {}

class Widget {
  const Widget();
}

class BuildContext {}
