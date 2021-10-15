import 'dart:collection';

const _array = [1, 2, 3, 4, 5, 6, 7, 8, 9];

void func() {
  const iterable = _array as Iterable<int>;
  final iterableLength = iterable.length;
  final iterableLastIndex = iterable.length - 1;

  iterable.last;
  iterable.elementAt(iterable.length - 1); // LINT
  iterable.elementAt(iterable.length - 2);
  iterable.elementAt(iterableLength - 1);
  iterable.elementAt(iterableLastIndex);
  iterable.elementAt(8);

  iterable
    ..elementAt(iterable.length - 1) // LINT
    ..elementAt(iterable.length - 2)
    ..elementAt(iterableLength - 1)
    ..elementAt(iterableLastIndex)
    ..elementAt(8);
}
