// ignore_for_file: unnecessary_cast, unused_local_variable

import 'dart:collection';

const _array = [1, 2, 3, 4, 5, 6, 7, 8, 9];

void func() {
  const iterable = _array as Iterable<int>;

  final firstOfIterable = iterable.first;
  final firstElementOfIterable = iterable.elementAt(0); // LINT
  final secondElementOfIterable = iterable.elementAt(1);

  iterable
    ..elementAt(2)
    ..elementAt(0) // LINT
    ..elementAt(1);

////////////////////////////////////////////////////////////////////////////////

  const list = _array;

  final firstOfList = list.first;
  final firstElementOfList1 = list.elementAt(0); // LINT
  final firstElementOfList2 = list[0]; // LINT
  final secondElementOfList1 = list.elementAt(1);
  final secondElementOfList2 = list[1];

  list
    ..elementAt(2)
    ..elementAt(0) // LINT
    ..elementAt(1)
    ..[2]
    ..[0] // LINT
    ..[1];

  (list
        ..[2]
        ..[0]) // LINT
      .length;

  list
    ..[2].toDouble()
    ..[0].toDouble(); // LINT

////////////////////////////////////////////////////////////////////////////////

  final set = _array.toSet();

  final firstOfSet = set.first;
  final firstElementOfSet = set.elementAt(0); // LINT
  final secondElementOfSet = set.elementAt(1);

  set
    ..elementAt(2)
    ..elementAt(0) // LINT
    ..elementAt(1);

////////////////////////////////////////////////////////////////////////////////

  final doubleLinkedQueue = DoubleLinkedQueue.of(_array);

  final firstOfDoubleLinkedQueue = doubleLinkedQueue.first;
  final firstElementOfDoubleLinkedQueue =
      doubleLinkedQueue.elementAt(0); // LINT
  final secondElementOfDoubleLinkedQueue = doubleLinkedQueue.elementAt(1);

  doubleLinkedQueue
    ..elementAt(2)
    ..elementAt(0) // LINT
    ..elementAt(1);

////////////////////////////////////////////////////////////////////////////////

  final hashSet = HashSet.of(_array);

  final firstOfHashSet = hashSet.first;
  final firstElementOfHashSet = hashSet.elementAt(0); // LINT
  final secondElementOfHashSet = hashSet.elementAt(1);

  hashSet
    ..elementAt(2)
    ..elementAt(0) // LINT
    ..elementAt(1);

////////////////////////////////////////////////////////////////////////////////

  final linkedHashSet = LinkedHashSet.of(_array);

  final firstOfLinkedHashSet = linkedHashSet.first;
  final firstElementOfLinkedHashSet = linkedHashSet.elementAt(0); // LINT
  final secondElementOfLinkedHashSet = linkedHashSet.elementAt(1);

  linkedHashSet
    ..elementAt(2)
    ..elementAt(0) // LINT
    ..elementAt(1);

////////////////////////////////////////////////////////////////////////////////

  final listQueue = ListQueue.of(_array);

  final firstOfListQueue = listQueue.first;
  final firstElementOfListQueue = listQueue.elementAt(0); // LINT
  final secondElementOfListQueue = listQueue.elementAt(1);

  listQueue
    ..elementAt(2)
    ..elementAt(0) // LINT
    ..elementAt(1);

////////////////////////////////////////////////////////////////////////////////

  final queue = Queue.of(_array);

  final firstOfQueue = queue.first;
  final firstElementOfQueue = queue.elementAt(0); // LINT
  final secondElementOfQueue = queue.elementAt(1);

  queue
    ..elementAt(2)
    ..elementAt(0) // LINT
    ..elementAt(1);

////////////////////////////////////////////////////////////////////////////////

  final splayTreeSet = SplayTreeSet.of(_array);

  final firstOfSplayTreeSet = splayTreeSet.first;
  final firstElementOfSplayTreeSet = splayTreeSet.elementAt(0); // LINT
  final secondElementOfSplayTreeSet = splayTreeSet.elementAt(1);

  splayTreeSet
    ..elementAt(2)
    ..elementAt(0) // LINT
    ..elementAt(1);

////////////////////////////////////////////////////////////////////////////////

  final unmodifiableListView = UnmodifiableListView<int>(_array);

  final firstOfUnmodifiableListView = unmodifiableListView.first;
  final firstElementOfUnmodifiableListView1 =
      unmodifiableListView.elementAt(0); // LINT
  final firstElementOfUnmodifiableListView2 = unmodifiableListView[0]; // LINT
  final secondElementOfUnmodifiableListView1 =
      unmodifiableListView.elementAt(1);
  final secondElementOfUnmodifiableListView2 = unmodifiableListView[1];

  unmodifiableListView
    ..elementAt(2)
    ..elementAt(0) // LINT
    ..elementAt(1)
    ..[2]
    ..[0] // LINT
    ..[1];

////////////////////////////////////////////////////////////////////////////////

  final unmodifiableSetView = UnmodifiableSetView<int>(_array.toSet());

  final firstOfUnmodifiableSetView = unmodifiableSetView.first;
  final firstElementOfUnmodifiableSetView =
      unmodifiableSetView.elementAt(0); // LINT
  final secondElementOfUnmodifiableSetView = unmodifiableSetView.elementAt(1);

  unmodifiableSetView
    ..elementAt(2)
    ..elementAt(0) // LINT
    ..elementAt(1);
}
