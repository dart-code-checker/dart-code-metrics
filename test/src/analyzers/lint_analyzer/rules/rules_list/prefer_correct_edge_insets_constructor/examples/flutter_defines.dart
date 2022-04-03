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

class EdgeInsetsDirectional {
  final double top;
  final double start;
  final double end;
  final double bottom;

  const EdgeInsetsDirectional.fromSTEB(
      this.start, this.top, this.end, this.bottom);

  const EdgeInsetsDirectional.all(double value)
      : start = value,
        top = value,
        end = value,
        bottom = value;

  const EdgeInsetsDirectional.only({
    this.start = 0.0,
    this.top = 0.0,
    this.end = 0.0,
    this.bottom = 0.0,
  });

  static const EdgeInsets zero = EdgeInsets.only();

  const EdgeInsetsDirectional.symmetric({
    double vertical = 0.0,
    double horizontal = 0.0,
  })  : start = horizontal,
        top = vertical,
        end = horizontal,
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
