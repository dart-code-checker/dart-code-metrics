class A {}

class B extends A {}

class Example4 {
  final a = A();
  final b = B();

  final res = a is B;
  final re = b is A; // LINT

  final String? nullable;
  final String regular;

  final s1 = nullable is String;
  final s2 = regular is String?; // LINT

  main() {
    ['1', '2'].whereType<String?>(); // LINT

    dynamic a;
    final list = <dynamic>[1, 'as', 1];
    a is String;
    list.whereType<String>();
    final myList = [1, 2];
    myList is List<int>; //LINT
    myList is List<Object>;
    myList.whereType<int>(); //LINT
    final result2 = a is dynamic;

    list.whereType();
  }
}
