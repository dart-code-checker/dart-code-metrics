import 'dart:async';

void function() async {
  final future = Future.delayed(Duration(microseconds: 100), () => 6);

  future.then((value) => print(value)); // LINT

  future..then((value) => print(value)); // LINT

  final value = await future;

  final anotherFuture = getFuture().then((value) => value + 5); // LINT

  final anotherValue = await anotherFuture;
}

Future<int> getFuture() {
  return Future.delayed(Duration(microseconds: 100), () => 5)
      .then((value) => value + 1); // LINT
}
