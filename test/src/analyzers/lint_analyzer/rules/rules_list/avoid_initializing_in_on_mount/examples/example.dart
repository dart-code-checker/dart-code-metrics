class MyComponent extends Component {
  late final int x;

  int y;

  @override
  void onMount() {
    x = 1; // LINT
    y = 2;
  }
}

class Component {
  void onMount() {}
}
