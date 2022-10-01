class Animal {}

class NotAnimal {}

class HomeAnimal extends Animal {}

class Dog extends HomeAnimal {}

class Cat extends HomeAnimal {}

void checkSameOrInheritor() {
  final cat = Cat();

  final check = cat is! Cat; // LINT
  final check = cat is Dog;
  final check = cat is! Dog; // LINT
  final check = cat is! NotAnimal; // LINT

  final Cat? nullableCat = null;

  final check = nullableCat is! Cat;

  final dynamic a;
  final check = a is! int;

  final Object b;
  final check = b is! int;
}

void check<T>() {
  final T b;
  final check = b is! int;
}
