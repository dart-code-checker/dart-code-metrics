checkWhereType() {
  Iterable<String?> a = [];
  Iterable<String> b = [];

  // Unnecessary String? in List<String>
  ['1', '2'].whereType<String?>(); // LINT

  // Necessary because the type of list dynamic
  <dynamic>[1, 'as', 1].whereType<String>();

  // Unnecessary int in List<int>
  [1, 2].whereType<int>(); //LINT

  // whereType without typecast
  [1, 2].whereType();

  //  Necessary because the type of list String?
  a.whereType<String>();

  // Unnecessary String? in List<String?>
  a.whereType<String?>(); // LINT

  // Unnecessary String in List<String>
  b.whereType<String>(); // LINT

  // Unnecessary String? in List<String>
  b.whereType<String?>(); // LINT

  // Example from Flutter repo
  <A?>[].whereType<B>();
}

checkTypeAssertion() {
  final a = A();
  final b = B();

  final res = a is B;
  final re = b is A; // LINT

  final String? nullable;
  final String regular;

  final s1 = nullable is String;
  final s2 = regular is String?; // LINT

  dynamic a;
  a is String;
  final myList = [1, 2];
  myList is List<int>; //LINT
  myList is List<Object>; //LINT
  final result2 = a is dynamic;
}

class A {}

class B extends A {}
