const _array = [1, 2, 3, 4, 5, 6, 7, 8, 9];

void func() {
  final set = _array.toSet();
  final setLength = set.length;
  final setLastIndex = set.length - 1;

  set.last;
  set.elementAt(set.length - 1); // LINT
  set.elementAt(set.length - 2);
  set.elementAt(setLength - 1);
  set.elementAt(setLastIndex);
  set.elementAt(8);

  set
    ..elementAt(set.length - 1) // LINT
    ..elementAt(set.length - 2)
    ..elementAt(setLength - 1)
    ..elementAt(setLastIndex)
    ..elementAt(8);
}
