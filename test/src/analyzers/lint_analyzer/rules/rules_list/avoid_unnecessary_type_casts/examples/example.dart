class Example1 {
  final regularString = '';
  final String? nullableString = null;

  void main() {
    final result = regularString as String; // LINT
    final result2 = nullableString as String?; // LINT
    final result3 = regularString as String?; // LINT
    final result4 = nullableString as String;
  }
}

class Example2 {
  final Animal animal = Animal();
  final HomeAnimal homeAnimal = HomeAnimal();
  final Cat cat = Cat();
  final Dog dog = Dog();

  void main() {
    final result = animal as HomeAnimal;
    final result = animal as Animal; // LINT
    final result = cat as HomeAnimal; // LINT
    final result = cat as Animal; // LINT
    final result = dog as HomeAnimal; // LINT
    final result = dog as Animal; // LINT
    final result = animal as Dog;
    final result = animal as Cat;
    final result = homeAnimal as Cat;
    final result = homeAnimal as Dog;
    final result = homeAnimal as dynamic;
    final String regular;
    final s2 = regular as String?; // LINT
  }
}

class Example3 {
  final myList = <int>[1, 2, 3];

  void main() {
    final result = myList as List<int>; // LINT
  }
}

class Animal {}

class HomeAnimal extends Animal {}

class Dog extends HomeAnimal {}

class Cat extends HomeAnimal {}
