class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
        ),
      );
}

class MyWidget2 extends StatelessWidget {
  const MyWidget2({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          label: const Text('label'),
          onPressed: () {},
        ),
      );
}

class MyWidget3 extends StatelessWidget {
  const MyWidget3({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        floatingActionButton: FloatingActionButton.large(
          onPressed: () {},
        ),
      );
}

class MyWidget4 extends StatelessWidget {
  const MyWidget4({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        floatingActionButton: FloatingActionButton.small(
          onPressed: () {},
        ),
      );
}

class MyWidget6 extends StatelessWidget {
  const MyWidget6({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        floatingActionButton: FloatingActionButton(
          heroTag: 'heroTag',
          onPressed: () {},
        ),
      );
}

class MyWidget7 extends StatelessWidget {
  const MyWidget7({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          heroTag: 'heroTag',
          label: const Text('label'),
          onPressed: () {},
        ),
      );
}

class MyWidget8 extends StatelessWidget {
  const MyWidget8({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        floatingActionButton: FloatingActionButton.large(
          heroTag: 'heroTag',
          onPressed: () {},
        ),
      );
}

class MyWidget9 extends StatelessWidget {
  const MyWidget9({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        floatingActionButton: FloatingActionButton.small(
          heroTag: 'heroTag',
          onPressed: () {},
        ),
      );
}
