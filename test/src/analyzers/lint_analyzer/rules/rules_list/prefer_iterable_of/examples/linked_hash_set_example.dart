import 'dart:collection';

void main() {
  const hashSet = LinkedHashSet.of([1, 2, 3, 4, 5, 6, 7, 8, 9]);

  final copy = LinkedHashSet<int>.from(hashSet); // LINT
  final numSet = LinkedHashSet<num>.from(hashSet); // LINT

  final intSet = LinkedHashSet<int>.from(numSet);

  final unspecifedSet = LinkedHashSet.from(hashSet); // LINT

  final dynamicSet = LinkedHashSet<dynamic>.from([1, 2, 3]);
  final copy = LinkedHashSet<int>.from(dynamicSet);
  final dynamicCopy = LinkedHashSet.from(dynamicSet);

  final objectSet = LinkedHashSet<Object>.from([1, 2, 3]);
  final copy = LinkedHashSet<int>.from(objectSet);
}
