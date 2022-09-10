class Animal {}

class NotAnimal {}

class HomeAnimal extends Animal {}

class Dog extends HomeAnimal {}

class Cat extends HomeAnimal {}

void checkSameOrInheritor() {
  final cat = Cat();

  final check = cat is! Cat; // Lint
  final check = cat is Dog;
  final check = cat is! Dog; // LINT
  final check = cat is! NotAnimal; // Lint
}
