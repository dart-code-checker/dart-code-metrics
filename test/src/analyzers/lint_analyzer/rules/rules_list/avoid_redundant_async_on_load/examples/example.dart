import 'dart:async';

class MyComponent extends Component {
  // LINT
  @override
  Future<void> onLoad() {
    print('hello');
  }
}

class MyComponent extends Component {
  // LINT
  @override
  FutureOr<void> onLoad() {
    print('hello');
  }
}

class MyComponent extends Component {
  // LINT
  @override
  FutureOr<void> onLoad() async {
    print('hello');
  }
}

class MyComponent extends Component {
  @override
  Future<void> onLoad() async {
    await someAsyncMethod();
  }

  Future<void> someAsyncMethod() => Future.value(null);
}

class MyComponent extends Component {
  @override
  Future<void> onLoad() async {
    return someAsyncMethod();
  }

  Future<void> someAsyncMethod() => Future.value(null);
}

class MyComponent extends Component {
  @override
  Future<void> onLoad() => someAsyncMethod();

  Future<void> someAsyncMethod() => Future.value(null);
}

class MyComponent extends Component {
  @override
  void onLoad() {
    print('hello');
  }
}

class Component {
  FutureOr<void> onLoad() {}
}
