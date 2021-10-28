const _array = [1, 2, 3, 4, 5, 6, 7, 8, 9];

void func() {
  const list = _array;
  final listLength = list.length;
  final listLastIndex = list.length - 1;

  list.last;
  list.elementAt(list.length - 1); // LINT
  list.elementAt(list.length - 2);
  list.elementAt(listLength - 1);
  list.elementAt(listLastIndex);
  list.elementAt(8);
  list[list.length - 1]; // LINT
  list[list.length - 2];

  list
    ..elementAt(list.length - 1) // LINT
    ..elementAt(list.length - 2)
    ..elementAt(listLength - 1)
    ..elementAt(listLastIndex)
    ..elementAt(8)
    ..[list.length - 1] // LINT
    ..[list.length - 2];

  (list
        ..[list.length - 2]
        ..[list.length - 1]) // LINT
      .length;

  list
    ..[list.length - 2].toDouble()
    ..[list.length - 1].toDouble(); // LINT
}
