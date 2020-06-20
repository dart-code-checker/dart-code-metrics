double pi() => 3.14;

abstract class Foo {
  double twoPi();
}

class Bar implements Foo {
  @override
  double twoPi() => 2 * pi();
}

class Rectangle {
  double left, top, width, height;

  Rectangle(this.left, this.top, this.width, this.height);

  // Define two calculated properties: right and bottom.
  double get right => left + width;
  set right(double value) => left = value - width;
  double get bottom => top + height;
  set bottom(double value) => top = value - height;
}
