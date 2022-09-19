import 'dart:collection';

void main() {
  const queue = Queue.of([1, 2, 3, 4, 5, 6, 7, 8, 9]);

  final copy = Queue<int>.from(queue); // LINT
  final numQueue = Queue<num>.from(queue); // LINT

  final intQueue = Queue<int>.from(numQueue);

  final unspecifedQueue = Queue.from(queue); // LINT

  final dynamicQueue = Queue<dynamic>.from([1, 2, 3]);
  final copy = Queue<int>.from(dynamicQueue);
  final dynamicCopy = Queue.from(dynamicQueue);

  final objectQueue = Queue<Object>.from([1, 2, 3]);
  final copy = Queue<int>.from(objectQueue);
}
