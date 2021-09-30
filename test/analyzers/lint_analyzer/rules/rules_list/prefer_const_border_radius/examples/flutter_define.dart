class BorderRadius {
  final Radius topLeft;
  final Radius topRight;
  final Radius bottomLeft;
  final Radius bottomRight;

  const BorderRadius.all(Radius radius)
      : this.only(
          topLeft: radius,
          topRight: radius,
          bottomLeft: radius,
          bottomRight: radius,
        );

  BorderRadius.circular(double radius) : this.all(Radius.circular(radius));

  const BorderRadius.only({
    this.topLeft = Radius.zero,
    this.topRight = Radius.zero,
    this.bottomLeft = Radius.zero,
    this.bottomRight = Radius.zero,
  });
}

class Radius {
  final double x;
  final double y;

  const Radius.circular(double radius) : this.elliptical(radius, radius);

  const Radius.elliptical(this.x, this.y);

  static const Radius zero = Radius.circular(0);
}

class ClipRRect extends Widget {
  final Widget? child;
  final BorderRadius? borderRadius;

  const ClipRRect({this.child, this.borderRadius});
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
