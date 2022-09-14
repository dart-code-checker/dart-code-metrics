void main() {
  const array = [1, 2, 3, 4, 5, 6, 7, 8, 9];

  final copy = List<int>.from(array); // LINT
  final numList = List<num>.from(array); // LINT

  final intList = List<int>.from(numList);

  final unspecifedList = List.from(array); // LINT

  final dynamicArray = <dynamic>[1, 2, 3];
  final copy = List<int>.from(dynamicArray);
  final dynamicCopy = List.from(dynamicArray);

  final objectArray = <Object>[1, 2, 3];
  final copy = List<int>.from(objectArray);
}
