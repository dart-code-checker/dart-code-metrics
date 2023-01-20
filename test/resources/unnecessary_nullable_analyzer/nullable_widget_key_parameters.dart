class MyWidget extends StatelessWidget {
  const MyWidget(super.key);
}

class Widget {
  final Key? key;

  const Widget(this.key);
}

class StatelessWidget extends Widget {
  const StatelessWidget(super.key);
}

class Key {}

class GlobalKey extends Key {}

class AnotherWidget extends Widget {
  final void Function(String?) onSubmit;

  const AnotherWidget({required this.onSubmit}) : super(null);
}
