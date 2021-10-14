import 'dart:collection';

const _array = [1, 2, 3, 4, 5, 6, 7, 8, 9];

void func() {
  final splayTreeSet = SplayTreeSet.of(_array);
  final splayTreeSetLength = splayTreeSet.length;
  final splayTreeSetLastIndex = splayTreeSet.length - 1;

  splayTreeSet.last;
  splayTreeSet.elementAt(splayTreeSet.length - 1); // LINT
  splayTreeSet.elementAt(splayTreeSet.length - 2);
  splayTreeSet.elementAt(splayTreeSetLength - 1);
  splayTreeSet.elementAt(splayTreeSetLastIndex);
  splayTreeSet.elementAt(8);

  splayTreeSet
    ..elementAt(splayTreeSet.length - 1) // LINT
    ..elementAt(splayTreeSet.length - 2)
    ..elementAt(splayTreeSetLength - 1)
    ..elementAt(splayTreeSetLastIndex)
    ..elementAt(8);
}
