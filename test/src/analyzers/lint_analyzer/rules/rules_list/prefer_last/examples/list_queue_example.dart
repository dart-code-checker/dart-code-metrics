import 'dart:collection';

const _array = [1, 2, 3, 4, 5, 6, 7, 8, 9];

void func() {
  final listQueue = ListQueue.of(_array);
  final listQueueLength = listQueue.length;
  final listQueueLastIndex = listQueue.length - 1;

  listQueue.last;
  listQueue.elementAt(listQueue.length - 1); // LINT
  listQueue.elementAt(listQueue.length - 2);
  listQueue.elementAt(listQueueLength - 1);
  listQueue.elementAt(listQueueLastIndex);
  listQueue.elementAt(8);

  listQueue
    ..elementAt(listQueue.length - 1) // LINT
    ..elementAt(listQueue.length - 2)
    ..elementAt(listQueueLength - 1)
    ..elementAt(listQueueLastIndex)
    ..elementAt(8);
}
