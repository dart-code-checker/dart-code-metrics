void main() {
  {
    dynamic key = 1;

    final regularMap = Map<int, String>();
    regularMap[key] = "value"; // LINT
  }

  {
    Object? key = 1;

    final regularMap = Map<int, String>();
    regularMap[key] = "value"; // LINT
  }
}
