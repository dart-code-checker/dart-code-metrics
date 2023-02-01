class MyComponent extends Component {
  @override
  void update(double dt) {
    final newVector = Vector2(10, 10); // LINT
  }
}

class MyComponent extends Component {
  final _temporaryVector = Vector2.zero();

  @override
  void update(double dt) {
    _temporaryVector.setValues(10, 10);
  }
}

class MyComponent extends Component {
  final vector1 = Vector2(10, 10);
  final vector2 = Vector2(20, 20);

  @override
  void update(double dt) {
    final addVector = vector1 + vector2; // LINT
    final subVector = vector1 - vector2; // LINT
  }
}

class Component {
  void onMount() {}
}

class Vector2 {
  final double x;
  final double y;

  const Vector2(this.x, this.y);

  const Vector2.zero()
      : x = 0,
        y = 0;

  void setValues(double x, double y) {
    this.x = x;
    this.y = y;
  }

  @override
  Vector2 operator /(double scale) => this;

  @override
  Vector2 operator +(double scale) => this;

  @override
  Vector2 operator -(double scale) => this;

  @override
  Vector2 operator *(double scale) => this;
}
