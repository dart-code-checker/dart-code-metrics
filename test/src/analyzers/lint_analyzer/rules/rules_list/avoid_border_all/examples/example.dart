class MyWidget extends StatelessWidget {
  Widget build(BuildContext context) => Column(children: [
        const Container(border: Border.fromBorderSide(BorderSide())),
        Container(border: Border.all()), // LINT
        Container(
          border: Border.all(
            color: const Color(0),
          ),
        ), // LINT
        Container(
          border: Border.all(
            color: const Color(0),
            width: 1,
          ),
        ), // LINT
        Container(
          border: Border.all(
            color: const Color(0),
            width: 1,
            style: BorderStyle.none,
          ),
        ), // LINT
        Container(
          border: Border.all(
            color: const Color(0),
            width: foo(),
            style: BorderStyle.none,
          ),
        ),
        Container(
          border: Border.all(
            color: Theme.of(context).color,
          ),
        ),
        Container(
          border: Border.all(
            color: const Color(0),
            width: someBool ? 1 : 0,
            style: BorderStyle.none,
          ),
        ),
        Container(
          border: Border.all(
            color: const Color(0),
            width: someInt,
            style: BorderStyle.none,
          ),
        ),
      ]);

  var someBool = false;
  var someInt = 5;

  double foo() => 20.0;
}

class Border {
  factory Border.all({
    Color color = const Color(0xFF000000),
    double width = 1.0,
    BorderStyle style = BorderStyle.solid,
  }) {
    final side = BorderSide(color: color, width: width, style: style);

    return Border.fromBorderSide(side);
  }

  const Border.fromBorderSide(BorderSide _);
}

enum BorderStyle {
  none,
  solid,
}

class BorderSide {
  final Color color;
  final double width;
  final BorderStyle style;

  const BorderSide({
    this.color = const Color(0xFF000000),
    this.width = 1.0,
    this.style = BorderStyle.solid,
  });
}

class Color {
  final int value;

  const Color(int value) : value = value & 0xFFFFFFFF;
}

class Container extends Widget {
  final Widget? child;
  final Border? border;

  const Container({this.child, this.border});
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

class Theme {
  const color = Color(0);

  static Color of(BuildContext context) => color;
}
