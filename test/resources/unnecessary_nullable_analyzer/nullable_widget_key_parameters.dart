class MyWidget extends StatelessWidget {
  const MyWidget(Key? key) : super(key);
}

class Widget {
  final Key? key;

  const Widget(this.key);
}

class StatelessWidget extends Widget {
  const StatelessWidget(Key? key) : super(key);
}

class Key {}

class GlobalKey extends Key {}
