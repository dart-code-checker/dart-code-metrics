import 'dart:collection';

const _array = [1, 2, 3, 4, 5, 6, 7, 8, 9];

void func() {
  final doubleLinkedQueue = DoubleLinkedQueue.of(_array);
  final doubleLinkedQueueLength = doubleLinkedQueue.length;
  final doubleLinkedQueueLastIndex = doubleLinkedQueue.length - 1;

  doubleLinkedQueue.last;
  doubleLinkedQueue.elementAt(doubleLinkedQueue.length - 1); // LINT
  doubleLinkedQueue.elementAt(doubleLinkedQueue.length - 2);
  doubleLinkedQueue.elementAt(doubleLinkedQueueLength - 1);
  doubleLinkedQueue.elementAt(doubleLinkedQueueLastIndex);
  doubleLinkedQueue.elementAt(8);

  doubleLinkedQueue
    ..elementAt(doubleLinkedQueue.length - 1) // LINT
    ..elementAt(doubleLinkedQueue.length - 2)
    ..elementAt(doubleLinkedQueueLength - 1)
    ..elementAt(doubleLinkedQueueLastIndex)
    ..elementAt(8);
}
