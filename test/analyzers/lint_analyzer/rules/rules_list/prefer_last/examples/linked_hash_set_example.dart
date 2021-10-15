import 'dart:collection';

const _array = [1, 2, 3, 4, 5, 6, 7, 8, 9];

void func() {
  final linkedHashSet = LinkedHashSet.of(_array);
  final linkedHashSetLength = linkedHashSet.length;
  final linkedHashSetLastIndex = linkedHashSet.length - 1;

  linkedHashSet.last;
  linkedHashSet.elementAt(linkedHashSet.length - 1); // LINT
  linkedHashSet.elementAt(linkedHashSet.length - 2);
  linkedHashSet.elementAt(linkedHashSetLength - 1);
  linkedHashSet.elementAt(linkedHashSetLastIndex);
  linkedHashSet.elementAt(8);

  linkedHashSet
    ..elementAt(linkedHashSet.length - 1) // LINT
    ..elementAt(linkedHashSet.length - 2)
    ..elementAt(linkedHashSetLength - 1)
    ..elementAt(linkedHashSetLastIndex)
    ..elementAt(8);
}
