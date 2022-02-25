void main() {
  {
    final primitiveMap = Map<int, String>();

    primitiveMap[42] = "value";
    primitiveMap["str"] = "value"; // LINT

    final a1 = primitiveMap[42];
    final a2 = primitiveMap["str"]; // LINT

    primitiveMap.containsKey(42);
    primitiveMap.containsKey("str"); // LINT

    primitiveMap.containsValue("value");
    primitiveMap.containsValue(100); // LINT

    primitiveMap.remove(42);
    primitiveMap.remove("str"); // LINT
  }

  {
    final inheritanceMap = Map<Animal, Flower>();

    inheritanceMap[Animal()] = "value";
    inheritanceMap[HumanExtendsAnimal()] = "value";
    inheritanceMap[DogImplementsAnimal()] = "value";
    inheritanceMap[Flower()] = "value"; // LINT

    final b1 = inheritanceMap[Animal()];
    final b2 = inheritanceMap[HumanExtendsAnimal()];
    final b3 = inheritanceMap[DogImplementsAnimal()];
    final b4 = inheritanceMap[Flower()]; // LINT

    inheritanceMap.containsKey(DogImplementsAnimal());
    inheritanceMap.containsKey(Flower()); // LINT

    inheritanceMap.containsValue(Flower());
    inheritanceMap.containsValue(DogImplementsAnimal()); // LINT

    inheritanceMap.remove(DogImplementsAnimal());
    inheritanceMap.remove(Flower()); // LINT
  }

  {
    final myMap = MyMapSubClass();
    myMap[42] = "value";
    myMap["str"] = "value"; // LINT
    myMap.containsKey(42);
    myMap.containsKey("str"); // LINT
  }

  {
    <int>[1, 2, 3].contains(42);
    <int>[1, 2, 3].contains("str"); // LINT

    Iterable<int>.generate(10).contains(42);
    Iterable<int>.generate(10).contains("str"); // LINT
  }
}

class Animal {}

class HumanExtendsAnimal extends Animal {}

class DogImplementsAnimal implements Animal {}

class Flower {}

class MyMapSubClass extends Map<int, String> {}
