import 'flutter_define.dart';

const _constRadius = BorderRadius.all(16);
final _finalRadius = BorderRadius.circular(8); // LINT
const _constValue = 55;
final _finalValue = 66;

class MyWidget extends StatelessWidget {
  static final staticRadius = BorderRadius.circular(32); // LINT

  Widget build(BuildContext _) {
    final buildMethodRadius = BorderRadius.circular(230); // LINT

    return Column(children: [
      const Container(borderRadius: _constRadius),
      Container(borderRadius: BorderRadius.circular(32)), // LINT
      Container(borderRadius: staticRadius),
      Container(borderRadius: buildMethodRadius),
      Container(borderRadius: BorderRadius.circular(_finalValue)),
      Container(borderRadius: BorderRadius.circular(_constValue)), // LINT
      Container(borderRadius: BorderRadius.circular(_constValue-_finalValue)),
    ]);
  }
}
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
