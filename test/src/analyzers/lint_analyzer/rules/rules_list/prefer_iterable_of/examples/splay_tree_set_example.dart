import 'dart:collection';

void main() {
  const hashSet = SplayTreeSet.of([1, 2, 3, 4, 5, 6, 7, 8, 9]);

  final copy = SplayTreeSet<int>.from(hashSet); // LINT
  final numSet = SplayTreeSet<num>.from(hashSet); // LINT

  final intSet = SplayTreeSet<int>.from(numSet);

  final unspecifedSet = SplayTreeSet.from(hashSet); // LINT

  final dynamicSet = SplayTreeSet<dynamic>.from([1, 2, 3]);
  final copy = SplayTreeSet<int>.from(dynamicSet);
  final dynamicCopy = SplayTreeSet.from(dynamicSet);

  final objectSet = SplayTreeSet<Object>.from([1, 2, 3]);
  final copy = SplayTreeSet<int>.from(objectSet);
}
