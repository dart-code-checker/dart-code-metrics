int simpleFunction(double index) {
  if (index < 10) {
    return 10;
  } else if (index < 20) {
    return 20;
  } else if (index < 40) {
    if (index < 30) {
      return 30;
    }

    return 40;
  }

  return 100;
}

class SimpleClass {
  String _value1;
  int _value2;

  SimpleClass(String text) {
    _value1 = text;
    if (_value1.isNotEmpty) {
      _value2 = _value1.length;
    } else {
      _value2 = 0;
    }
  }

  int get lettersCount => _value1.split(' ').fold(0, (prevValue, element) {
        if (element.isNotEmpty) {
          return prevValue + element.length;
        } else {
          return prevValue;
        }
      });
}

final instance = SimpleClass('example text');
