class MyWidget extends StatelessWidget {
  Widget build(BuildContext context) => Column(children: [
        Expanded(child: Container()), // LINT
        Expanded(child: SizeBox()), // LINT
        Expanded(child: SizeBox(child: Container())),
        Expanded(child: Container(child: SizeBox())),
        Spacer(),
      ]);
}

class Container extends Widget {
  final Widget? child;

  const Container({this.child});
}

class Expanded extends Widget {
  final Widget? child;

  const Expanded({this.child});
}

class SizeBox extends Widget {
  final Widget? child;

  const SizeBox({this.child});
}

class Spacer extends Widget {
  const Spacer();
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
