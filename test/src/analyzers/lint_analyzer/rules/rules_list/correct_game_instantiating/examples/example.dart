class MyGamePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GameWidget(game: MyFlameGame()); // LINT
  }
}

class MyGamePage extends StatefulWidget {
  @override
  State<MyGamePage> createState() => _MyGamePageState();
}

class _MyGamePageState extends State<MyGamePage> {
  late final _game = MyFlameGame();

  @override
  Widget build(BuildContext context) {
    return GameWidget(game: _game);
  }
}

class _MyGamePageState extends State<MyGamePage> {
  @override
  Widget build(BuildContext context) {
    return GameWidget(game: MyFlameGame()); // LINT
  }
}

class MyGamePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GameWidget.controlled(gameFactory: MyFlameGame.new);
  }
}

class GameWidget extends Widget {
  final Widget game;

  GameWidget({required this.game});

  GameWidget.controlled({required GameFactory<Widget> gameFactory}) {
    this.game = gameFactory();
  }
}

class MyFlameGame extends Widget {}

typedef GameFactory<T> = T Function();

class StatefulWidget extends Widget {}

class StatelessWidget extends Widget {}

class Widget {
  const Widget();
}

class BuildContext {}

abstract class State<T> {
  void initState();

  void setState(VoidCallback callback) => callback();
}
