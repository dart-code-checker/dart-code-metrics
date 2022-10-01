void main() {
  const set = {1, 2, 3, 4, 5, 6, 7, 8, 9};

  final copy = Set<int>.from(set); // LINT
  final numSet = Set<num>.from(set); // LINT

  final intSet = Set<int>.from(numSet);

  final unspecifedSet = Set.from(set); // LINT

  final dynamicSet = <dynamic>{1, 2, 3};
  final copy = Set<int>.from(dynamicSet);
  final dynamicCopy = Set.from(dynamicSet);

  final objectSet = <Object>{1, 2, 3};
  final copy = Set<int>.from(objectSet);
}
