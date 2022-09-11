class Example1 {
  final regularString = '';
  final String? nullableString = null;

  void main() {
    final result = regularString is String; // LINT
    final result2 = nullableString is String?; // LINT
    final result3 = regularString is String?; // LINT
    final result4 = nullableString is String;
  }
}

class Example2 {
  final Animal animal = Animal();
  final HomeAnimal homeAnimal = HomeAnimal();
  final Cat cat = Cat();
  final Dog dog = Dog();

  void main() {
    final result = animal is HomeAnimal;
    final result = animal is Animal; // LINT
    final result = cat is HomeAnimal; // LINT
    final result = cat is Animal; // LINT
    final result = dog is HomeAnimal; // LINT
    final result = dog is Animal; // LINT
    final result = animal is Dog;
    final result = animal is Cat;
    final result = homeAnimal is Cat;
    final result = homeAnimal is Dog;
    final result = homeAnimal is dynamic;
  }
}

class Example3 {
  final myList = <int>[1, 2, 3];

  void main() {
    final result = myList is List<int>; // LINT
  }
}

class Animal {}

class HomeAnimal extends Animal {}

class Dog extends HomeAnimal {}

class Cat extends HomeAnimal {}

// new cases

void checkNullability() {
  final Cat nonNullableCat = Cat();
  final Cat? nullableCat = Cat();

  final nonNullableCats = <Cat>[];
  final nullableCats = <Cat?>[];

  final check1 = nonNullableCat is Cat; // Lint
  final check2 = nonNullableCat is Cat?; // Lint
  final check3 = nullableCat is Cat;
  final check4 = nullableCat is Cat?; // Lint

  final check5 = nonNullableCats.whereType<Cat>().isEmpty; // Lint
  final check6 = nonNullableCats.whereType<Cat?>().isEmpty; // Lint
  final check7 = nullableCats.whereType<Cat>().isEmpty;
  final check8 = nullableCats.whereType<Cat?>().isEmpty; // Lint
}

void checkSameOrInheritor() {
  final cat = Cat();
  final homeAnimal = HomeAnimal();

  final dogs = <Dog>[];
  final animals = <Animal>[];

  final check1 = cat is Cat?; // Lint
  final check1Not = cat is! Cat?; // Lint
  final check2 = cat is Dog;
  final check2Not = cat is! Dog; // LINT
  final check3 = cat is Animal; // Lint
  final check3Not = cat is! Animal; // Lint
  final check4 = homeAnimal is Dog?;
  final check4Not = homeAnimal is! Dog?;

  final check5 = dogs.whereType<Dog?>().isEmpty; // Lint
  final check6 = dogs.whereType<Cat>().isEmpty;
  final check7 = dogs.whereType<Animal>().isEmpty; // Lint
  final check8 = animals.whereType<Animal?>().isEmpty; // Lint
}
