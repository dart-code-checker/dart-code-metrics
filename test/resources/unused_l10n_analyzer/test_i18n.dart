class TestI18n {
  static const String field = 'field';

  static String get getter => 'getter'; // LINT

  static String method(String value) => value;

  static String secondMethod(String value, num number) =>
      value + number.toString();
}

class S {
  static const String field = 'field'; // LINT

  static String get getter => 'getter';

  static String method(String value) => value; // LINT

  static String secondMethod(String value, num number) => // LINT
      value + number.toString();
}
