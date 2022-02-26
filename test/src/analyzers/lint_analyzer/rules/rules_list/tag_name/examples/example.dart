class _Fruit {
  static const _kTag = '_Fruit';
}

class Apple extends _Fruit {
  static const _kTag = 'Orange'; // LINT
}

class Orange extends _Fruit {
  static const _kTag = 'Orange';
}
