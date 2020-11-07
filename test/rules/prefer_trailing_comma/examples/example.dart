void firstFunction(
    String firstArgument, String secondArgument, String thirdArgument) {
  return;
}

void secondFunction(
  String firstArgument,
  String secondArgument,
  String thirdArgument,
) {
  firstFunction('some string', 'some other string',
      'and another string for length exceed');
}

void thirdFunction(String arg1) {
  firstFunction('', '', '');
}

class TestClass {
  void firstMethod(
      String firstArgument, String secondArgument, String thirdArgument) {
    return;
  }

  void secondMethod() {
    firstMethod(
      'some string',
      'some other string',
      'and another string for length exceed',
    );

    firstMethod('some string', 'some other string',
        'and another string for length exceed');
  }

  void thirdMethod(
    String arg1,
  ) {
    firstMethod(
      arg1,
      '',
      '',
    );
    firstFunction(
      arg1,
      '',
      '',
    );
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

enum SecondEnum {
  firstItem,
}

enum ThirdEnum { firstItem }

class FirstClass {
  final int firstField;
  final int secondField;
  final int thirdField;
  final int forthField;

  const FirstClass(
      this.firstField, this.secondField, this.thirdField, this.forthField);
}

const instance = FirstClass(0, 0, 0, 0);

final firstArray = ['some string'];
final secondArray = [
  'some string',
  'some other string',
  'and another string for length exceed'
];
final thirdArray = [
  'some string',
];

final firstSet = {'some string'};
final secondSet = {
  'some string',
  'some other string',
  'and another string for length exceed'
};
final thirdSet = {
  'some string',
};

final firstMap = {'some string': 'some string'};
final secondMap = {
  'some string': 'and another string for length exceed',
  'and another string for length exceed': 'and another string for length exceed'
};
final thirdMap = {
  'some string': 'some string',
};
