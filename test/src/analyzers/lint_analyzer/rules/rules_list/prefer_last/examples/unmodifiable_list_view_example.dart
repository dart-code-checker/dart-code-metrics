import 'dart:collection';

const _array = [1, 2, 3, 4, 5, 6, 7, 8, 9];

void func() {
  final unmodifiableListView = UnmodifiableListView<int>(_array);
  final unmodifiableListViewLength = unmodifiableListView.length;
  final unmodifiableListViewLastIndex = unmodifiableListView.length - 1;

  unmodifiableListView.last;
  unmodifiableListView.elementAt(unmodifiableListView.length - 1); // LINT
  unmodifiableListView.elementAt(unmodifiableListView.length - 2);
  unmodifiableListView.elementAt(unmodifiableListViewLength - 1);
  unmodifiableListView.elementAt(unmodifiableListViewLastIndex);
  unmodifiableListView.elementAt(8);
  unmodifiableListView[unmodifiableListView.length - 1]; // LINT
  unmodifiableListView[unmodifiableListView.length - 2];

  unmodifiableListView
    ..elementAt(unmodifiableListView.length - 1) // LINT
    ..elementAt(unmodifiableListView.length - 2)
    ..elementAt(unmodifiableListViewLength - 1)
    ..elementAt(unmodifiableListViewLastIndex)
    ..elementAt(8)
    ..[unmodifiableListView.length - 1] // LINT
    ..[unmodifiableListView.length - 2];

  (unmodifiableListView
        ..[unmodifiableListView.length - 2]
        ..[unmodifiableListView.length - 1]) // LINT
      .length;

  unmodifiableListView
    ..[unmodifiableListView.length - 2].toDouble()
    ..[unmodifiableListView.length - 1].toDouble(); // LINT
}
