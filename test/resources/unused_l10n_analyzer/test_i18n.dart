import 'base_localization.dart';

class TestI18n extends BaseLocalization {
  static const String field = 'field';

  static String get getter => 'getter'; // LINT

  static String method(String value) => value;

  static String secondMethod(String value, num number) =>
      value + number.toString();

  String regularMethod(String value) => value;

  String get regularGetter => 'regular getter'; // LINT

  String get anotherRegularGetter => 'another regular getter';

  final String regularField = 'regular field';

  TestI18n.of(String value) {
    print(value);
  }
}

class S {
  static const String field = 'field'; // LINT

  static String get getter => 'getter';

  static String method(String value) => value; // LINT

  static String secondMethod(String value, num number) => // LINT
      value + number.toString();

  String regularMethod(String value) => value;

  String anotherRegularMethod(String value) => value;

  String get regularGetter => 'regular getter';

  String get anotherRegularGetter => 'another regular getter';

  final String regularField = 'regular field'; // LINT

  String get proxyGetter => 'proxy getter';

  final String proxyField = 'proxy field';

  String proxyMethod(String value) => value;

  // ignore: prefer_constructors_over_static_methods
  static S of(String value) {
    print(value);

    return S();
  }

  // ignore: prefer_constructors_over_static_methods
  static S get current => S();

  static const _privateField = 'hello';

  String get _privateGetter => 'regular getter';

  String _privateMethod() => 'hi';
}

class SofS {
  final S l10n;

  const SofS(this.l10n);
}

class L10nClass {
  String method(String value) => value;

  String get regularGetter => 'regular getter';

  final String regularField = 'regular field';

  L10nClass._();
}

class L10nWrapper {}

extension L10nExtension on L10nWrapper {
  L10nClass get l10n => L10nClass._();
}
