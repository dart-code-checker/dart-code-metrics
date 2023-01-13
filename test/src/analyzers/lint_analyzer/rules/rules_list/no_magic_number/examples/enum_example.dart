enum ExampleMagicNumbers {
  second(2),
  third(3);

  final int value;

  const ExampleMagicNumbers(this.value);
}

enum ExampleNamedMagicNumbers {
  second(value: 2),
  third(value: 3);

  final int value;

  const ExampleNamedMagicNumbers({required this.value});
}
