void main() {
  print('Hello');

  customTest(null, () => 1 == 1); // LINT

  otherTestMethod(null, () => 1 == 1); // LINT

  excludedTestMethod(null, () => 1 == 1);
}
