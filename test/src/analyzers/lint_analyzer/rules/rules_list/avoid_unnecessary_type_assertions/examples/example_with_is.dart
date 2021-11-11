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
