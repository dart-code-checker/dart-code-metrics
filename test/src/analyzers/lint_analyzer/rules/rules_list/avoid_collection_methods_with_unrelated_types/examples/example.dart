void main() {
  final primitiveMap = Map<int, String>();
  // write
  primitiveMap[42] = "value";
  primitiveMap["wrong_key_type"] = "value"; // LINT
  // read
  final a1 = primitiveMap[42];
  final a2 = primitiveMap["wrong_key_type"]; // LINT

  final inheritanceMap = Map<Animal, String>();
  // write
  inheritanceMap[Animal()] = "value";
  inheritanceMap[HumanExtendsAnimal()] = "value";
  inheritanceMap[DogImplementsAnimal()] = "value";
  inheritanceMap[Flower()] = "value"; // LINT
  // read
  final b1 = inheritanceMap[Animal()];
  final b2 = inheritanceMap[HumanExtendsAnimal()];
  final b3 = inheritanceMap[DogImplementsAnimal()];
  final b4 = inheritanceMap[Flower()]; // LINT
}

class Animal {}

class HumanExtendsAnimal extends Animal {}

class DogImplementsAnimal implements Animal {}

class Flower {}
