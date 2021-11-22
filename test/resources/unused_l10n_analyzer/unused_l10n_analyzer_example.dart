import 'test_i18n.dart';

void main() {
  final _ = TestI18n.method('value');

  S.getter;

  TestI18n.of('').regularMethod('some-string');

  TestI18n.of('').regularField.trim();
}

class SomeClass {
  final field = TestI18n.field;

  void method() {
    S.of('').regularMethod('');
    S.of('').regularGetter;
  }
}
