Future<void> usesAwait(Future<String> later) async {
  print(await later);
}

Future<void> asyncError() async {
  throw 'Error!';
}

Future<void> asyncValue() async => 'value';

// LINT
Future<int> fastestBranch(Future<int> left, Future<int> right) async {
  return Future.any([left, right]);
}

class SomeClass {
  void syncMethod() {}

  Future<int> asyncMethod() async => 1;

  // LINT
  Future<String> anotherAsyncMethod() async => Future.value('value');

  @override
  Future<String> overrideMethod() async => Future.value('value');

  Future<String> someAsyncMethod(Future<String> later) => later;

  Future<void> report(Iterable<String> records) async {
    if (records.isEmpty) {
      return;
    }

    print(records);
  }

  Future<void> returnNullable(SomeClass? instance) async {
    return instance?.report([]);
  }

  Stream<int> buildStream() async* {
    for (int i = 0; i < 10; i++) {
      yield i;
    }
  }
}

class WithFunctionField {
  final Function(void) onSelected;
  final Function(void) onSelectedNamed;

  const WithFunctionField(this.onSelected, {required this.onSelectedNamed});
}

void main() {
  final instance = SomeClass();

  WithFunctionField(
    () async => instance.someAsyncMethod(), // LINT
    onSelectedNamed: () async => instance.someAsyncMethod(), // LINT
  );

  WithFunctionField(onSelectedNamed: () async {
    if (shouldRefresh) return apiCall();
  });
}

Future<void> apiCall() {
  return Future.value();
}
