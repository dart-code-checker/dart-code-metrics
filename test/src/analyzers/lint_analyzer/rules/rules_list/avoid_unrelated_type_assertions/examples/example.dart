import 'dart:async';

class Example1 {
  final regularString = '';
  final String? nullableString = null;

  void main() {
    final result = regularString is int; // LINT
    final result2 = nullableString is int?; // LINT
    final result3 = regularString is String?;
    final result4 = nullableString is String;
    final result5 = regularString is bool; // LINT
  }
}

class Example2 {
  final Animal animal = Animal();
  final NotAnimal notAnimal = NotAnimal();
  final HomeAnimal homeAnimal = HomeAnimal();
  final Cat cat = Cat();
  final Dog dog = Dog();
  final NotCat notCat = NotCat();

  void main() {
    final result = animal is HomeAnimal;
    final result = animal is NotAnimal; // LINT
    final result = cat is HomeAnimal;
    final result = cat is Animal;
    final result = cat is NotAnimal; // LINT
    final result = cat is NotCat; // LINT
    final result = dog is HomeAnimal;
    final result = dog is Animal;
    final result = dog is NotAnimal; // LINT
    final result = animal is Dog;
    final result = animal is Cat;
    final result = homeAnimal is Cat;
    final result = homeAnimal is Dog;
    final result = homeAnimal is dynamic;
  }

  void generic<T>() {
    final result = animal is T;
  }
}

class Example3 {
  final myList = <int>[1, 2, 3];

  void main() {
    final result = myList is List<String>; // LINT
    final result = myList is List<int>;
    final result = myList is List<Object>;
    final result = myList is List<dynamic>;
  }
}

class Animal {}

class NotAnimal {}

class HomeAnimal extends Animal {}

class Dog extends HomeAnimal {}

class Cat extends HomeAnimal {}

class NotCat extends NotAnimal {}

void checkNullability() {
  final Cat nonNullableCat = Cat();
  final Cat? nullableCat = Cat();

  final check1 = nonNullableCat is Cat;
  final check2 = nonNullableCat is Cat?;
  final check3 = nullableCat is Cat;
  final check4 = nullableCat is Cat?;
  final check5 = nonNullableCat is NotCat; // LINT
  final check6 = nonNullableCat is NotCat?; // LINT
}

void checkSameOrInheritor() {
  final cat = Cat();
  final homeAnimal = HomeAnimal();

  final check1 = cat is Cat?;
  final check1Not = cat is! Cat?;
  final check2 = cat is Dog; // LINT
  final check2Not = cat is! Dog;
  final check3 = cat is Animal;
  final check3Not = cat is! Animal;
  final check4 = homeAnimal is Dog?;
  final check4Not = homeAnimal is! Dog?;
}

bool isTypeOf<ThisType, OfType>() => _Instance<ThisType>() is _Instance<OfType>;

class _Instance<T> {
  T field;

  _Instance() : assert(field is Object?);

  String show<T>(Object? object) {
    Iterable<Object?> objects = [];

    if (objects is Iterable<T>) {
      return '';
    }

    if (object is Hello) {
      return '';
    }

    final FutureOr<void> result;
    if (result is Future) {
      return '';
    }

    final FutureOr<T> generic;
    if (generic is T) {
      return '';
    }

    final FutureOr<bool> generic2;
    if (generic2 is bool) {
      return '';
    }

    return object is Cat ? 'cat' : 'unknown';
  }
}

enum Hello {
  world1,
  world2,
}
