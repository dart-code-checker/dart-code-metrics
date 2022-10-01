class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final aLocalColor = true ? Colors.red : Colors.black;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: aLocalColor),
      ),
    );
  }
}

enum Colors {
  red,
  black,
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

class Container extends Widget {
  final Widget? child;
  final Border? border;

  const Container({this.child, this.border});
}

class StatelessWidget extends Widget {}

class Widget {
  const Widget();
}

class BuildContext {}
