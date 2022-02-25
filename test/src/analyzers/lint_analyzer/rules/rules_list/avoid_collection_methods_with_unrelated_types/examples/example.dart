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

  // sub-class of `Map`, `Iterable` etc should also be supported
  {
    final myMap = MyMapSubClass();
    var c1 = myMap[42];
    var c2 = myMap["str"]; // LINT
    myMap.containsKey(42);
    myMap.containsKey("str"); // LINT
  }

  {
    <int>[1, 2, 3].contains(42);
    <int>[1, 2, 3].contains("str"); // LINT

    Iterable<int>.generate(10).contains(42);
    Iterable<int>.generate(10).contains("str"); // LINT

    <int>{1, 2, 3}.contains(42);
    <int>{1, 2, 3}.contains("str"); // LINT
  }

  {
    final primitiveList = [10, 20, 30];
    primitiveList.remove(20);
    primitiveList.remove("str"); // LINT
  }

  {
    final primitiveSet = {10, 20, 30};

    primitiveSet.contains(42);
    primitiveSet.contains("str"); // LINT

    primitiveSet.containsAll(Iterable<int>.empty());
    primitiveSet.containsAll(Iterable<String>.empty()); // LINT

    primitiveSet.difference(<int>{});
    primitiveSet.difference(<String>{}); // LINT

    primitiveSet.intersection(<int>{});
    primitiveSet.intersection(<String>{}); // LINT

    primitiveSet.lookup(42);
    primitiveSet.lookup("str"); // LINT

    primitiveSet.remove(42);
    primitiveSet.remove("str"); // LINT

    primitiveSet.removeAll(Iterable<int>.empty());
    primitiveSet.removeAll(Iterable<String>.empty()); // LINT

    primitiveSet.retainAll(Iterable<int>.empty());
    primitiveSet.retainAll(Iterable<String>.empty()); // LINT
  }
}

class Animal {}

class HumanExtendsAnimal extends Animal {}

class DogImplementsAnimal implements Animal {}

class Flower {}

class MyMapSubClass extends Map<int, String> {}
