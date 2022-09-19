import 'dart:collection';

void main() {
  const queue = DoubleLinkedQueue.of([1, 2, 3, 4, 5, 6, 7, 8, 9]);

  final copy = DoubleLinkedQueue<int>.from(queue); // LINT
  final numQueue = DoubleLinkedQueue<num>.from(queue); // LINT

  final intQueue = DoubleLinkedQueue<int>.from(numQueue);

  final unspecifedQueue = DoubleLinkedQueue.from(queue); // LINT

  final dynamicQueue = DoubleLinkedQueue<dynamic>.from([1, 2, 3]);
  final copy = DoubleLinkedQueue<int>.from(dynamicQueue);
  final dynamicCopy = DoubleLinkedQueue.from(dynamicQueue);

  final objectQueue = DoubleLinkedQueue<Object>.from([1, 2, 3]);
  final copy = DoubleLinkedQueue<int>.from(objectQueue);
}
