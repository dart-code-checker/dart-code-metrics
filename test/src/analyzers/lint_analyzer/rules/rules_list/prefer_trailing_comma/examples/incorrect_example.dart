// LINT
void firstFunction(
    String firstArgument, String secondArgument, String thirdArgument) {
  return;
}

void secondFunction() {
  firstFunction('some string', 'some other string',
      'and another string for length exceed'); // LINT
}

void thirdFunction(String someLongVarName, void Function() someLongCallbackName,
    String arg3) {} // LINT

class TestClass {
  // LINT
  void firstMethod(
      String firstArgument, String secondArgument, String thirdArgument) {
    return;
  }

  void secondMethod() {
    firstMethod('some string', 'some other string',
        'and another string for length exceed'); // LINT

    thirdFunction('some string', () {
      return;
    }, 'some other string'); // LINT
  }
}

enum FirstEnum {
  firstItem,
  secondItem,
  thirdItem,
  forthItem,
  fifthItem,
  sixthItem
}

class FirstClass {
  final num firstField;
  final num secondField;
  final num thirdField;
  final num forthField;

  // LINT
  const FirstClass(
      this.firstField, this.secondField, this.thirdField, this.forthField);
}

const instance =
    FirstClass(3.14159265359, 3.14159265359, 3.14159265359, 3.14159265359);

final secondArray = [
  'some string',
  'some other string',
  'and another string for length exceed' // LINT
];

final secondSet = {
  'some string',
  'some other string',
  'and another string for length exceed' // LINT
};

final secondMap = {
  'some string': 'and another string for length exceed',
  // LINT
  'and another string for length exceed': 'and another string for length exceed'
};
