import 'dart:collection';

const _array = [1, 2, 3, 4, 5, 6, 7, 8, 9];

void func() {
  final queue = Queue.of(_array);
  final queueLength = queue.length;
  final queueLastIndex = queue.length - 1;

  queue.last;
  queue.elementAt(queue.length - 1); // LINT
  queue.elementAt(queue.length - 2);
  queue.elementAt(queueLength - 1);
  queue.elementAt(queueLastIndex);
  queue.elementAt(8);

  queue
    ..elementAt(queue.length - 1) // LINT
    ..elementAt(queue.length - 2)
    ..elementAt(queueLength - 1)
    ..elementAt(queueLastIndex)
    ..elementAt(8);
}
