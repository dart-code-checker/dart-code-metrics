var answer = 42; // LINT
var evenNumbers = [1, 2, 3].where((element) => element.isEven); // LINT
const a = 1;
final b = 1;
static const noted2 = '';

void function() {}

class Foo {
  static int? a; // LINT
  static dynamic c; // LINT
  final int? b;
  dynamic c2;
  const d = 1;
  static const noted = '';
  void function() {}
}
