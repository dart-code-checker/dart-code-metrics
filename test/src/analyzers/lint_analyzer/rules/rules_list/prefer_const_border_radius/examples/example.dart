const _constRadius = BorderRadius.all(Radius.circular(0.0));
final _finalRadius = BorderRadius.circular(1.0); // LINT
const _constValue = 10.0;
final _finalValue = 15.0;

class MyWidget extends StatelessWidget {
  static final staticRadius = BorderRadius.circular(2.0); // LINT

  double foo() => 20.0;

  Widget build(BuildContext _) {
    final buildMethodRadius = BorderRadius.circular(3.0); // LINT
    var buildMethodRadiusVar = BorderRadius.circular(4.0); // LINT

    return Column(children: [
      const ClipRRect(borderRadius: _constRadius),
      ClipRRect(borderRadius: BorderRadius.circular(5.0)), // LINT
      ClipRRect(borderRadius: staticRadius),
      ClipRRect(borderRadius: buildMethodRadius),
      ClipRRect(borderRadius: buildMethodRadiusVar),
      ClipRRect(borderRadius: BorderRadius.circular(_finalValue)),
      ClipRRect(borderRadius: BorderRadius.circular(_constValue)), // LINT
      ClipRRect(borderRadius: BorderRadius.circular(foo())),
      ClipRRect(
        borderRadius: BorderRadius.circular(
          _constValue == 10.0 ? 25.0 : 30.0,
        ),
      ),
    ]);
  }
}

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
