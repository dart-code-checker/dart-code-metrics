// ignore_for_file: no-empty-block

class SimpleClass {
  String _value1;
  int _value2;

  SimpleClass(String text) {
    _value1 = text;
    _value2 = _value1.isNotEmpty ? _value1.length : 0;
  }

  int get lettersCount => _value1.split(' ').fold(
        0,
        (prevValue, element) => element.isNotEmpty
            ? prevValue + element.length
            : prevValue + _value2,
      );
}

class Spacecraft {
  String name;
  DateTime launchDate;

  // Constructor, with syntactic sugar for assignment to members.
  Spacecraft(this.name, this.launchDate) {
    // Initialization code goes here.
  }

  // Named constructor that forwards to the default one.
  Spacecraft.unLaunched(String name) : this(name, null);

  int get launchYear => launchDate?.year; // read-only non-final property

  // Method.
  void describe() {
    print('Spacecraft: $name');
    if (launchDate != null) {
      final years = DateTime.now().difference(launchDate).inDays ~/ 365;
      print('Launched: $launchYear ($years years ago)');
    } else {
      print('Un-launched');
    }
  }
}

abstract class EmptyAbstractClass {}
