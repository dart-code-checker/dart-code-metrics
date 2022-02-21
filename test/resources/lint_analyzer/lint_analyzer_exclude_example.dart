// ignore_for_file: prefer_const_declarations, literal_only_boolean_expressions
class ExcludeExample {
  void test() {
    late final int value;

    if (5 > 0) {
      value = 123;
    }

    print(value.toString());
  }
}
