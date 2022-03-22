class MyWidget extends StatelessWidget {
  Widget build(BuildContext _) => Column(children: [
        Container(
          padding: const EdgeInsets.fromLTRB(1, 1, 0, 0), // LINT
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(1, 1, 1, 1), // LINT
        ),
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 10), // LINT
        ),
        Container(
          padding: const EdgeInsets.only(
              top: 0, left: 0, bottom: 0, right: 0), // LINT
        ),
        Container(
          padding: const EdgeInsets.only(
              top: 10, left: 5, bottom: 10, right: 5), // LINT
        ),
      ]);
}

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
