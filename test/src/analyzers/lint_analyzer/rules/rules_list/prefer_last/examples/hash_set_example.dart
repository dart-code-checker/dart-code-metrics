import 'dart:collection';

const _array = [1, 2, 3, 4, 5, 6, 7, 8, 9];

void func() {
  final hashSet = HashSet.of(_array);
  final hashSetLength = hashSet.length;
  final hashSetLastIndex = hashSet.length - 1;

  hashSet.last;
  hashSet.elementAt(hashSet.length - 1); // LINT
  hashSet.elementAt(hashSet.length - 2);
  hashSet.elementAt(hashSetLength - 1);
  hashSet.elementAt(hashSetLastIndex);
  hashSet.elementAt(8);

  hashSet
    ..elementAt(hashSet.length - 1) // LINT
    ..elementAt(hashSet.length - 2)
    ..elementAt(hashSetLength - 1)
    ..elementAt(hashSetLastIndex)
    ..elementAt(8);
}
