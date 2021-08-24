import 'dart:async';

class SomeService {
  static void staticVoidMethod() {
    return;
  }

  static String staticMethod() {
    return 'string';
  }

  void voidMethod() {
    final list = [
      1,
      2,
      3,
    ];

    list.insert(0, 4);
    list.remove(1); // LINT

    final removed = list.remove(1);

    list
      ..sort()
      ..any((element) => element > 1);

    (list..sort()).contains(1); // LINT

    futureMethod(); // LINT
    voidFutureMethod();

    await futureMethod(); // LINT
    await voidFutureMethod();

    final futureResult = await futureMethod();

    futureOrMethod(); // LINT
    futureOrVoidMethod();

    await futureOrMethod(); // LINT
    await futureOrVoidMethod();
    await futureOrNullMethod();

    final futureOrResult = await futureOrMethod();

    final str = staticMethod();
    final _ = staticMethod();

    nullMethod();

    final props = ClassWithProps();

    props.name; // LINT
    props.name; // LINT

    props
      ..name
      ..value;

    props.field; // LINT
  }

  Future<int> futureMethod() async {
    return 1;
  }

  Future<void> voidFutureMethod() async {
    return;
  }

  Null nullMethod() {
    return null;
  }

  FutureOr<int> futureOrMethod() {
    return 1;
  }

  FutureOr<void> futureOrVoidMethod() {
    return;
  }

  FutureOr<Null> futureOrNullMethod() {
    return null;
  }
}

class ClassWithProps {
  String get name => 'name';
  String get value => 'value';

  String field = 'field';
}

String function() {
  return 'string';
}

void main() {
  function(); // LINT

  SomeService.staticVoidMethod();
  SomeService.staticMethod(); // LINT
}
