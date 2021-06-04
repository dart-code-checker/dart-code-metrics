class CoolWidget {
  Widget build() {
    // LINT
    return Padding(
      child: Container(),
    );
  }
}

class AnotherWidget {
  Widget build() {
    return Padding(
      child: Icon(),
    );
  }
}

class Container extends Widget {
  final EdgeInsetsGeometry? padding;
  final Widget child;

  const Container(this.padding);
}

class Padding extends Widget {
  final EdgeInsetsGeometry? padding;
  final Widget child;

  const Padding(this.padding);
}

class Icon extends Widget {}

class Widget {}
