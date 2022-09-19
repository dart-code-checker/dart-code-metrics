import 'dart:collection';

void main() {
  const hashSet = HashSet.of([1, 2, 3, 4, 5, 6, 7, 8, 9]);

  final copy = HashSet<int>.from(hashSet); // LINT
  final numSet = HashSet<num>.from(hashSet); // LINT

  final intSet = HashSet<int>.from(numSet);

  final unspecifedSet = HashSet.from(hashSet); // LINT

  final dynamicSet = HashSet<dynamic>.from([1, 2, 3]);
  final copy = HashSet<int>.from(dynamicSet);
  final dynamicCopy = HashSet.from(dynamicSet);

  final objectSet = HashSet<Object>.from([1, 2, 3]);
  final copy = HashSet<int>.from(objectSet);
}
