int calculateSum(int a, int b) {
  final sum = a + b;

  return sum; // LINT
}

int calculateSum(int a, int b) {
  final delta = a - b, sum = a + b;

  return sum; // LINT
}

final calculateSum = (int a, int b) {
  final delta = a - b, sum = a + b;

  return sum; // LINT
};

class Geometry {
  static void calculateRectangleArea(int width, int height) {
    final result = width * height;

    return result; // LINT
  }
}

void returnNull() {
  final String? x;

  return x; // LINT
}

int calculateSomething(int a, int b) {
  final x = a * b;

  return x * x; // OK
}

int calculateSum(int a, int b) {
  final sum = a + b, delta = a - b;

  return sum; // OK, "sum" variable not immediately preceding return statement
}

void calculateSum(int a, int b) {
  try {
    final sum = a + b;

    return sum; // LINT
  } catch (e) {
    final sum = 0;

    return sum; // LINT
  }

  return 0;
}

void calculateSomething(bool condition, int a, int b) {
  for (var i = 0; i < 10; i++) {
    final result = a * b;

    return result; // LINT
  }
  if (condition) {
    final result = a + b;

    return result; // LINT
  }
  return 0;
}
