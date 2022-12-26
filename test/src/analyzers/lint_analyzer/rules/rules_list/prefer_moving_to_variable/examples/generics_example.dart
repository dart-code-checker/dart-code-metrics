void main() {
  final a = GetIt.instance<Object>();
  final b = GetIt.instance<String>();
}

class GetIt {
  static final _instance = GetIt();

  static GetIt get instance => _instance;

  T get<T extends Object>() => 'str' as T;

  T call<T extends Object>() => get<T>;
}

enum AnotherEnum {
  firstValue,
  anotherValue,
}
