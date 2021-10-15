import 'dart:collection';

const _array = [1, 2, 3, 4, 5, 6, 7, 8, 9];

void func() {
  final unmodifiableSetView = UnmodifiableSetView<int>(_array.toSet());
  final unmodifiableSetViewLength = unmodifiableSetView.length;
  final unmodifiableSetViewLastIndex = unmodifiableSetView.length - 1;

  unmodifiableSetView.last;
  unmodifiableSetView.elementAt(unmodifiableSetView.length - 1); // LINT
  unmodifiableSetView.elementAt(unmodifiableSetView.length - 2);
  unmodifiableSetView.elementAt(unmodifiableSetViewLength - 1);
  unmodifiableSetView.elementAt(unmodifiableSetViewLastIndex);
  unmodifiableSetView.elementAt(8);

  unmodifiableSetView
    ..elementAt(unmodifiableSetView.length - 1) // LINT
    ..elementAt(unmodifiableSetView.length - 2)
    ..elementAt(unmodifiableSetViewLength - 1)
    ..elementAt(unmodifiableSetViewLastIndex)
    ..elementAt(8);
}
