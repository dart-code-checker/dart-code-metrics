import 'package:collection/collection.dart';

void main() {
  const queue = QueueList.of([1, 2, 3, 4, 5, 6, 7, 8, 9]);

  final copy = QueueList<int>.from(queue);
  final numQueue = QueueList<num>.from(queue);

  final intQueue = QueueList<int>.from(numQueue);

  final unspecifedQueue = QueueList.from(queue);

  final dynamicQueue = QueueList<dynamic>.from([1, 2, 3]);
  final copy = QueueList<int>.from(dynamicQueue);
  final dynamicCopy = QueueList.from(dynamicQueue);

  final objectQueue = QueueList<Object>.from([1, 2, 3]);
  final copy = QueueList<int>.from(objectQueue);
}
