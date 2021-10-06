class TestI18n {
  static const String field = 'field';

  static String get getter => 'getter'; // LINT

  static String method(String value) => value;

  static String secondMethod(String value, num number) =>
      value + number.toString();
}
