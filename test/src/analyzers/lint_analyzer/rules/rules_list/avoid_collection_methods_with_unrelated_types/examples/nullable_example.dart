void main() {
  {
    final regularMap = Map<int, String>();
    regularMap[null] = "value"; // LINT

    final nullableMap = Map<int?, String>();
    nullableMap[42] = "value";
    nullableMap[null] = "value";
    final value = nullableMap[null];
    nullableMap["str"] = "value"; // LINT
  }

  {
    final regularList = [10, 20, 30];
    regularList.remove(null); // LINT

    final nullableList = <int?>[10, 20, 30, null];
    nullableList.remove(null);
    nullableList.remove(20);
    nullableList.remove("str"); // LINT
  }

  {
    final regularSet = {10, 20, 30};
    regularSet.contains(null); // LINT

    final nullableSet = {10, 20, 30, null};
    nullableSet.contains(null);
    nullableSet.contains(42);
    nullableSet.contains("str"); // LINT
  }
}
