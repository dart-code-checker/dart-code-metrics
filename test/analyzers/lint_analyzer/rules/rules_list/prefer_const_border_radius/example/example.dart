// ignore_for_file: unused_element
const _defaultRadius = BorderRadius.all(16);
final _defaultFinalRadius = BorderRadius.circular(8); // LINT

class BorderRadius {
  final dynamic t;

  const BorderRadius.all(this.t);

  BorderRadius.circular(this.t);

  static BorderRadius someWidget({required BorderRadius borderRadius}) =>
      borderRadius;
}

class Test {
  void test() {
    BorderRadius.someWidget(borderRadius: BorderRadius.circular(32));
  }
}
