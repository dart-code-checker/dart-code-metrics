import 'dart:collection';

void main() {
  const queue = ListQueue.of([1, 2, 3, 4, 5, 6, 7, 8, 9]);

  final copy = ListQueue<int>.from(queue); // LINT
  final numQueue = ListQueue<num>.from(queue); // LINT

  final intQueue = ListQueue<int>.from(numQueue);

  final unspecifedQueue = ListQueue.from(queue); // LINT

  final dynamicQueue = ListQueue<dynamic>.from([1, 2, 3]);
  final copy = ListQueue<int>.from(dynamicQueue);
  final dynamicCopy = ListQueue.from(dynamicQueue);

  final objectQueue = ListQueue<Object>.from([1, 2, 3]);
  final copy = ListQueue<int>.from(objectQueue);
}
