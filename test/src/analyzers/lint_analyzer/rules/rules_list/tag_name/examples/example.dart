class Fruit {
  static const _kTag = 'Fruit';
}

class Apple extends Fruit {
  static const _kTag = 'Orange'; // LINT
}

class Orange extends Fruit {
  static const TAG = 'Or' + 'an' + 'ge';
}

class _PlantState {
  static const _kTag = 'Plant'; // should not lint
}

const TAG = 'FileLevelTagIsIgnored';
