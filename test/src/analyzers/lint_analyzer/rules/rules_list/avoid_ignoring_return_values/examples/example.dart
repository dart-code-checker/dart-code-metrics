// ignore_for_file: prefer_expression_function_bodies, unawaited_futures, cascade_invocations, unused_local_variable, unnecessary_statements, prefer_void_to_null, return_without_value

import 'dart:async';

class SomeService {
  static void staticVoidMethod() {
    return;
  }

  static String staticMethod() {
    return 'string';
  }

  Future<void> voidMethod() async {
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
    futureMethod().then((_) => null);
    voidFutureMethod();
    voidFutureMethod().then((_) => null);

    await futureMethod(); // LINT
    await futureMethod().then((_) => null);
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
    props.value; // LINT

    props
      ..name
      ..value;

    props.field; // LINT

    props.futureMixinMethod(); // LINT
    props.futureMixinMethod().then((_) => null);
    props.voidFutureMixinMethod();
    props.voidFutureMixinMethod().then((_) => null);

    await props.futureMixinMethod(); // LINT
    await props.futureMixinMethod().then((_) => null);
    await props.voidFutureMixinMethod();

    props.futureExtensionMethod(); // LINT
    props.futureExtensionMethod().then((_) => null);
    props.voidFutureExtensionMethod();
    props.voidFutureExtensionMethod().then((_) => null);

    await props.futureExtensionMethod(); // LINT
    await props.futureExtensionMethod().then((_) => null);
    await props.voidFutureExtensionMethod();
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

class ClassWithProps with MixinWithProp {
  String get name => 'name';
  String get value => 'value';

  String field = 'field';
}

mixin MixinWithProp {
  Future<int> futureMixinMethod() async {
    return 1;
  }

  Future<void> voidFutureMixinMethod() async {
    return;
  }
}

extension ClassWithPropsExtension on ClassWithProps {
  Future<int> futureExtensionMethod() async {
    return 1;
  }

  Future<void> voidFutureExtensionMethod() async {
    return;
  }
}

String function() {
  return 'string';
}

void main() {
  function(); // LINT

  SomeService.staticVoidMethod();
  SomeService.staticMethod(); // LINT
}
